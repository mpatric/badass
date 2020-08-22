class Admin::TagsController < ApplicationController
  layout 'admin'

  before_filter :require_user

  def index
    @tags = Tag.by_label
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def new
    @tag = Tag.new
  end

  def edit
    @tag = Tag.find(params[:id])
    check_access(@tag, 'edit')
  end

  def create
    @tag = Tag.new(tag_param)
    if @tag.save
      redirect_to(admin_tag_path(@tag), :notice => 'Created tag')
    else
      render :action => "new"
    end
  end

  def update
    @tag = Tag.find(params[:id])
    if params[:cancel]
      redirect_to(admin_tag_path(@tag))
    elsif check_access(@tag, 'update')
      @tag.attributes = tag_param
      did_change = @tag.changed?
      if @tag.save
        flash[:notice] = 'No changes' unless did_change
        flash[:notice] = 'Updated tag' if did_change
        redirect_to(admin_tag_path(@tag))
      else
        render :action => "edit"
      end
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    if check_access(@tag, 'delete')
      @tag.destroy
      redirect_to(admin_tags_path)
    end
  end

  private
    def check_access(tag, action)
      return true if tag.posts.published.all?{ |post| post.user_id == @current_user.id }
      flash[:error] = "Cannot #{action} a tag that is used by published posts not belonging to you"
      redirect_to(admin_tag_path(tag))
      false
    end

    def tag_param
      params.require(:tag).permit(:label, :permalink)
    end
end
