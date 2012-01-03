class Admin::PostsController < ApplicationController
  layout 'admin'
  
  before_filter :require_user
  
  DEFAULT_PAGE_SIZE = 20
  
  def index
    @tags = Tag.with_posts.by_label.uniq
    @tag = Tag.find(params[:tag_id]) unless params[:tag_id].blank?
    @publish_status = params[:publish_status] || 'all'
    @page = (params[:page] || 1).to_i
    @per_page = (params[:per_page] || DEFAULT_PAGE_SIZE).to_i
    all_posts = Post.by_date_descending
    all_posts = all_posts.with_tag(@tag) if @tag
    @posts = all_posts if @publish_status == 'all'
    @posts = all_posts.send(@publish_status.to_sym) unless @publish_status == 'all'
    @posts = @posts.paginate(:page => @page, :per_page => @per_page)
    @counts = {:all => all_posts.count, :current => all_posts.current.count, :outdated => all_posts.outdated.count, :unpublished => all_posts.unpublished.count}
  end
  
  def show
    @post = Post.find(params[:id])
  end
  
  def new
    @post = Post.new(:date => Date.today)
    @user = @current_user
  end
  
  def edit
    @post = Post.find(params[:id])
    if check_access(@post, 'edit')
      @user = @current_user
    end
  end
  
  def create
    @post = Post.new(params[:post].merge({:tags => parse_tag_ids(params[:tag_ids])}))
    @user = User.find(params[:post][:user_id])
    @post.user = @user
    if @post.save
      flash[:notice] = 'Created post'
      redirect_to(admin_post_path(@post))
    else
      render :action => "new"
    end
  end
  
  def update
    @post = Post.find(params[:id])
    @user = User.find(params[:post][:user_id])
    if params[:cancel]
      redirect_to(admin_post_path(@post))
    elsif check_access(@post, 'update')
      old_tags = @post.tags.collect(&:id).sort
      @post.attributes = params[:post].merge({:tags => parse_tag_ids(params[:tag_ids])})
      new_tags = @post.tags.collect(&:id).sort
      did_change = @post.change_to_bump_version?
      @post.version_draft += 1 if did_change
      updates = []
      updates << 'post' if did_change
      updates << 'tags for post' if old_tags != new_tags
      if @post.save
        flash[:notice] = "Updated #{updates.join(' and ')}" unless updates.empty?
        flash[:notice] = 'No changes' if updates.empty?
        redirect_to(admin_post_path(@post))
      else
        render :action => "edit"
      end
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    if check_access(@post, 'delete')
      @post.destroy
      flash[:notice] = 'Deleted post'
      redirect_to(admin_posts_path)
    end
  end
  
  def publish
    @post = Post.find(params[:post_id])
    if check_access(@post, 'publish')
      @post.publish!
      if @post.save
        flash[:notice] = 'Published post'
        redirect_to(admin_post_path(@post))
      else
        render :action => "show"
      end
    end
  end
  
  def quietly_publish
    @post = Post.find(params[:post_id])
    if check_access(@post, 'quietly publish')
      @post.publish!(true)
      if @post.save
        flash[:notice] = 'Quietly published post'
        redirect_to(admin_post_path(@post))
      else
        render :action => "show"
      end
    end
  end
  
  def revert
    @post = Post.find(params[:post_id])
    if check_access(@post, 'revert')
      @post.title_draft = @post.title
      @post.content_draft = @post.content
      @post.version_draft = @post.version
      if @post.save
        flash[:notice] = 'Reverted post'
        redirect_to(admin_post_path(@post))
      else
        render :action => "show"
      end
    end
  end
  
  def takedown
    @post = Post.find(params[:post_id])
    if check_access(@post, 'take down')
      @post.title = nil
      @post.content = nil
      @post.version = nil
      @post.first_published_at = nil
      @post.last_published_at = nil
      if @post.save
        flash[:notice] = 'Taken down post'
        redirect_to(admin_post_path(@post))
      else
        render :action => "show"
      end
    end
  end
  
  private
    def check_access(post, action)
      return true if post.user == @current_user
      flash[:error] = "Can only #{action} your own posts"
      redirect_to(admin_post_path(post))
      false
    end
    
    def parse_tag_ids(ids)
      tags = []
      unless ids.nil?
        ids.each do |k,v|
          tags << Tag.find(k.to_i) if v.to_i == 1
        end
      end
      tags.compact
    end
end
