class Admin::DashboardController < ApplicationController
  layout 'admin'
  
  before_filter :require_user
  
  def index
  end
end
