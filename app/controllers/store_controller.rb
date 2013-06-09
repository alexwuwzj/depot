class StoreController < ApplicationController

  before_filter :find_cart, :except => :empty_cart

  def index
    @product =Product.find_products_for_sale

  end

  def add_to_cart
    product=Product.find(params[:id])
    @current_item = @cart.add_product(product)
    respond_to do |format|
      format.js if request.xhr?
      format.html { redirect_to_index }
    end

  rescue ActiveRecord::RecordNotFound
    logger.error("Attempt to add invalid product #{params[:id]}")
    redirect_to_index("Invalid product")
  end

  def empty_cart
    session[:cart]=nil
    redirect_to_index
  end

  def check_out
    if @cart.items.empty?
      redirect_to_index("Your Cart is empty")
    end
    @order = Order.new
  end

  def save_order
    @cart = find_cart
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(@cart)
    if @order.save
      session[:cart] = nil
      redirect_to_index(I18n.t('flash.thanks'))
    else
      render :action => :check_out
    end
  end

  protected
  def authorize
  end

  private
  def redirect_to_index(msg = nil)
    flash[:notice]=msg if msg
    redirect_to :action => 'index'
  end

  private
  def find_cart
    @cart = session[:cart]||=Cart.new
  end

end
