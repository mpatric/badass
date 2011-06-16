class Admin::UsersController < ApplicationController
  layout 'admin'
  
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    unless User.can_register?
      flash[:error] = 'No more users can register'
      redirect_to login_path
    else
      @user = User.new
    end
  end
  
  def create
    unless User.can_register?
      flash[:error] = 'No more users can register'
      redirect_to login_path
    else
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = 'Registered!'
        redirect_back_or_default admin_profile_path
      else
        render :action => :new
      end
    end
  end
  
  def show
    @user = @current_user
  end
  
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if params[:cancel]
      redirect_back_or_default admin_profile_path
    else
      if @user.update_attributes(params[:user])
        flash[:notice] = "Updated profile"
        redirect_to admin_profile_path
      else
        render :action => :edit
      end
    end
  end
end
