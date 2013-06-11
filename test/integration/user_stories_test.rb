require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest

  fixtures :products

  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:rubybook)

    get "/store/index"
    assert_response :success
    assert_template "index"

    xml_http_request :post, "/store/add_to_cart", :id => ruby_book.id
    assert_response :success
    cart=session[:cart]
    assert_equal 1, cart.items.size
    assert_equal ruby_book, cart.items[0].product

    post "/store/check_out"
    assert_response :success
    assert_template "check_out"

    post_via_redirect "/store/save_order", :order => {:name => "Daves Tomas", :address => "test Address", :email => "test@yes.cn", :pay_type => "check" }
    assert_response :success
    assert_template "index"
    assert_equal 0, session[:cart].items.size
    orders = Order.find(:all)
    assert_equal 1, orders.size
    order = orders[0]
    assert_equal "Daves Tomas", order.name
    assert_equal "test Address", order.address
    assert_equal "test@yes.cn", order.email
    assert_equal "check", order.pay_type
    assert_equal 1, order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
  end

end
