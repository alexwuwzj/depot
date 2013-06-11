require 'test_helper'

class CartTest1 < ActiveSupport::TestCase
  fixtures :products

  def setup
    @cart = Cart.new
    @ruby = products(:rubybook)
    @rails = products(:railsbook)
  end

  test "add unique products" do

    @cart.add_product @ruby
    @cart.add_product @rails
    assert_equal 2, @cart.items.size
    assert_equal @ruby.price + @rails.price, @cart.total_price
  end

  test "add duplicate product" do
    @cart.add_product @ruby
    @cart.add_product @ruby
    assert_equal @ruby.price * 2, @cart.total_price
    assert_equal 1, @cart.items.size
    assert_equal 2, @cart.items[0].quantity
  end



end