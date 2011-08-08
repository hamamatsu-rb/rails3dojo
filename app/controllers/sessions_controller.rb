class SessionsController < ApplicationController
  def create
    user = User.find_or_create_by_name(params[:user_name])
    
    if user.valid?
      session[:user_id] = user.id
      redirect_to params[:before_path]
    else
      render :text => user.errors.full_messages.first
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to params[:before_path]
  end
end
