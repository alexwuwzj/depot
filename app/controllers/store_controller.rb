class StoreController < ApplicationController
  def index
    @cart=find_cart
    @product =Product.find_products_for_sale

  end

  def add_to_cart
    @cart=find_cart
    product=Product.find(params[:id])
    @cart.add_product(product)
      redirect_to_index
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to add invalid product #{params[:id]}")
      redirect_to_index("Invalid product")
  end

  def empty_cart
    session[:cart]=nil
    redirect_to_index("Your cart is currently empty")
  end

  private
  def redirect_to_index(msg = nil)
    flash[:notice]=msg if msg
    redirect_to :action => 'index'
  end

  private
  def find_cart
          session[:cart]||=Cart.new
  end

end
