require 'test_helper'

class CartTest < ActiveSupport::TestCase
  fixtures :products

  test "add unique products" do
    cart = Cart.new
    ruby = products(:rubybook)
    rails = products(:railsbook)
    cart.add_product ruby
    cart.add_product rails
    assert_equal 2, cart.items.size
    assert_equal ruby.price + rails.price, cart.total_price
  end

  test "add duplicate product" do
    cart = Cart.new
    ruby = products(:rubybook)
    cart.add_product ruby
    cart.add_product ruby
    assert_equal ruby.price * 2, cart.total_price
    assert_equal 1, cart.items.size
    assert_equal 2, cart.items[0].quantity
  end



end