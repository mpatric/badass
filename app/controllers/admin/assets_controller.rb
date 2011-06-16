class Admin::AssetsController < ApplicationController
  layout 'admin'
  
  before_filter :require_user
  
  DEFAULT_PAGE_SIZE = 20
  
  def index
    @page = (params[:page] || 1).to_i
    @per_page = (params[:per_page] || DEFAULT_PAGE_SIZE).to_i
    @assets = Asset.by_date_descending.paginate(:page => @page, :per_page => @per_page)
  end
  
  def show
    @asset = Asset.find(params[:id])
  end
  
  def new
    @asset = Asset.new
    @user = @current_user
  end
  
  def edit
    @asset = Asset.find(params[:id])
    if check_access(@asset, 'edit')
      @user = @current_user
    end
  end
  
  def create
    @asset = Asset.new(params[:asset])
    @user = User.find(params[:asset][:user_id])
    @asset.user = @user
    if @asset.save
      redirect_to(admin_asset_path(@asset), :notice => 'Created asset')
    else
      render :action => "new"
    end
  end
  
  def update
    @asset = Asset.find(params[:id])
    @user = User.find(params[:asset][:user_id])
    if params[:cancel]
      redirect_to(admin_asset_path(@asset))
    elsif check_access(@asset, 'update')
      @asset.attributes = params[:asset]
      did_change = @asset.changed?
      if @asset.save
        flash[:notice] = 'No changes' unless did_change
        flash[:notice] = 'Updated asset' if did_change
        redirect_to(admin_asset_path(@asset))
      else
        render :action => "edit"
      end
    end
  end
  
  def destroy
    @asset = Asset.find(params[:id])
    if check_access(@asset, 'delete')
      @asset.destroy
      redirect_to(admin_assets_path)
    end
  end
  
  private
    def check_access(asset, action)
      return true if asset.user == @current_user
      flash[:error] = "Can only #{action} your own assets"
      redirect_to(admin_asset_path(asset))
      false
    end
end
