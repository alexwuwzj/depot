class AdminController < ApplicationController
  def login
    if request.post?
      user = User.authenticate(params[:name],params[:password])
      if user
        uri = session[:original_url]
        session[:original_url] = nil
        session[:user_id] = user.id
        redirect_to(uri || {:action => 'index'})
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
  end

  def index
    @total_orders = Order.count
  end

end