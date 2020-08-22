class Admin::UserSessionsController < ApplicationController
  layout 'admin'

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
    render :layout => 'admin'
  end

  def create
    @user_session = UserSession.new(user_session_param.to_h)
    if @user_session.save
      flash[:notice] = "Login successful!"
      redirect_back_or_default admin_profile_path
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout successful!"
    redirect_back_or_default login_path
  end

  private
    def user_session_param
      params.require(:user_session).permit(:login, :password, :remember_me)
    end
end
