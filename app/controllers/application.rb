# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "store"

  before_filter :set_locals
  before_filter :authorize, :except => :login


  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => 'fc26a60aa8a584a462076a1a8dde816d'


  protected
  def set_locals
    session[:locale]= params[:locale] if params[:locale]
    I18n.locale = session[:locale] || I18n.default_locale
    local_path = "#{LOCAL_DIRECTORY}#{I18n.locale}.yml"
    unless I18n.load_path.include? local_path
      I18n.load_path << local_path
      I18n.backend.send(:init_translations)
    end

  rescue Exception => err
    logger.error err
    flash.now[:notice] = "#{I18n.locale} is available"
    I18n.load_path -= [local_path]
    I18n.locale = session[:locale] = I18n.default_locale
  end

  protected
  def authorize
    unless User.find_by_id(session[:user_id])
      session[:original_url] = request.request_uri
      flash[:notice] = "Please log in"
      redirect_to :controller => 'admin', :action => 'login'
    end
  end

  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password


end
