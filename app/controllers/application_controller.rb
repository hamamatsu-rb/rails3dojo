class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    @current_user
  rescue ActiveRecord::RecordNotFound => e
    nil
  end
  
  def login_required
    unless current_user
      flash[:error] = "This action is login required."
      url = request.env['HTTP_REFERER'] || root_url
      redirect_to url
    end
  end
end
