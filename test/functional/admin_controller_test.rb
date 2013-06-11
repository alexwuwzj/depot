require 'test_helper'

class AdminControllerTest < ActionController::TestCase

  fixtures :users

  test "the truth" do
    assert true
  end

  test "index" do
    get :index
    assert_redirected_to :action => "login"
    assert_equal "Please log in", flash[:notice]
  end

  test "index with user" do
    get :index, {}, {:user_id => users(:dave).id}
    assert_response :success
    assert_template "index"
  end

  test "login" do
    dave = users(:dave)
    post :login,{:name => dave.name, :password => 'secret'}
    assert_redirected_to :action => "index"
    assert_equal dave.id, session[:user_id]
  end

  test "bad password" do
    dave = users(:dave)
    post :login,{:name => dave.name, :password => 'wrong'}
    assert_template "login"
    assert_equal "Invalid user/password combination", flash[:notice]
  end

end
