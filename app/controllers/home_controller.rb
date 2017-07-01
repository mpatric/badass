class HomeController < ApplicationController
  layout 'home'
  
  before_filter :require_user, :only => :preview

  include BadassHelper
  
  def index
    @all_tags = Tag.with_published_posts.by_label.uniq
    @all_posts = Post.published.by_last_published
    @posts = @all_posts.published.by_last_published.paginate(:page => params[:page], :per_page => APP_CONFIG.posts_per_page)
  end
  
  def tag
    @all_tags = Tag.with_published_posts.by_label.uniq
    @tag = Tag.find_by_permalink(params[:label])
    @all_posts = Post.published.with_tag(@tag).by_last_published
    @posts = @all_posts.paginate(:page => params[:page], :per_page => APP_CONFIG.posts_per_page)
    render :template => 'home/index', :layout => 'home'
  end
  
  def post
    @post = Post.find_by_permalink(params[:permalink])
    if @post.nil? or !@post.published?
      render_404
    else
      @all_tags = Tag.with_published_posts.by_label.uniq
      @all_posts = Post.published.by_last_published.select{ |p| !(p.tags & @post.tags).empty? }.reject{ |p| p == @post }
      if !params[:comment]
        @comment = Comment.new
      elsif APP_CONFIG.comments_disabled or !@post.comments_open?
        if @post.published?
          redirect_to(@post.permalink_url)
        else
          render_404
        end
        return
      else
        # create comment
        user_ip = request.env['REMOTE_ADDR']
        user_agent = request.env['HTTP_USER_AGENT']
        referrer = request.env['HTTP_REFERER']
        title = params[:comment].delete(:title)
        @comment = Comment.new(params[:comment].merge({:user_ip => user_ip, :user_agent => user_agent, :referrer => referrer}))
        @comment.junk = true unless title.blank? # title is a non-visible field, if it's populated it was by a bot
        @comment.recaptcha_failed = true unless verify_recaptcha(model: @comment)
        if @comment.save
          logger.info "Comment posted with a title: #{title}" unless title.blank?
          if @comment.post.user.email.present? && !@comment.junk?
            AuthorMailer.new_comment(@comment).deliver
          end
          flash[:notice] = if @comment.junk?
            "Thank you for your comment, it will be vetted in due course."
          else
            "Thank you for your comment."
          end
          params.delete(:comment)
          redirect_to(@comment.permalink_url)
          return
        end
      end
      render :layout => 'post'
    end
  end
  
  def preview
    @post = Post.find_by_permalink(params[:permalink])
    if @post.nil?
      render_404
    else
      @all_tags = Tag.with_published_posts.by_label.uniq
      @all_posts = Post.published.by_last_published
      render :layout => 'post'
    end
  end
  
  def posts
    @tag = Tag.find_by_permalink(params[:tag]) if params[:tag]
    @posts = Post.published.with_tag(@tag).by_last_published if @tag
    @posts = Post.published.by_last_published unless @tag
    @posts = @posts.paginate(:page => 1, :per_page => APP_CONFIG.posts_in_feed) if APP_CONFIG.posts_in_feed
    respond_to do |format|
      format.atom
    end
  end
  
  def comments
    @post = Post.find_by_permalink(params[:post]) if params[:post]
    @comments = Comment.for_published_posts.for_post(@post).not_junk.by_date_descending if @post
    @comments = Comment.for_published_posts.not_junk.by_date_descending unless @post
    @comments = @comments.paginate(:page => 1, :per_page => APP_CONFIG.comments_in_feed) if APP_CONFIG.comments_in_feed
    respond_to do |format|
      format.atom
    end
  end
  
  def render_404(exception = nil)
    respond_to do |format|
      format.html { render :layout => nil, :file => "#{Rails.root}/public/404.html", :status => :not_found }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end
end