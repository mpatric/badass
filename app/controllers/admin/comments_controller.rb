class Admin::CommentsController < ApplicationController
  layout 'admin'

  before_filter :require_user

  DEFAULT_PAGE_SIZE = 20

  def index
    @posts = Post.by_date_descending
    @post = Post.find(params[:post_id]) unless params[:post_id].blank?
    @junk_status = params[:junk_status] || 'all'
    @page = (params[:page] || 1).to_i
    @per_page = (params[:per_page] || DEFAULT_PAGE_SIZE).to_i
    all_comments = Comment.by_date_descending
    all_comments = all_comments.for_post(@post) if @post
    @comments = all_comments if @junk_status == 'all'
    @comments = all_comments.send(@junk_status.to_sym) unless @junk_status == 'all'
    @comments = @comments.paginate(:page => @page, :per_page => @per_page)
    @counts = {:all => all_comments.count, :junk => all_comments.junk.count, :not_junk => all_comments.not_junk.count}
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def edit
    @comment = Comment.find(params[:id])
    if check_access(@comment, 'edit')
      @user = @current_user
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if params[:cancel]
      redirect_to(admin_comment_path(@comment))
    elsif check_access(@comment, 'update')
      @comment.attributes = comment_param
      did_change = @comment.changed?
      if @comment.save
        flash[:notice] = 'No changes' unless did_change
        flash[:notice] = 'Updated comment' if did_change
        redirect_to(admin_comment_path(@comment))
      else
        render :action => "edit"
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if check_access(@comment, 'delete')
      @comment.destroy
      flash[:notice] = 'Deleted comment'
      redirect_to(admin_comments_path(:post_id => @comment.post.id))
    end
  end

  def junk
    @comment = Comment.find(params[:comment_id])
    if check_access(@comment, 'junk')
      @comment.junk!
      redirect_to(admin_comment_path(@comment, :post_id => @comment.post.id))
    end
  end

  def notjunk
    @comment = Comment.find(params[:comment_id])
    if check_access(@comment, 'unjunk')
      @comment.not_junk!
      redirect_to(admin_comment_path(@comment, :post_id => @comment.post.id))
    end
  end

  def bulk_action
    count = 0
    if params[:check].present?
      if params[:delete].present?
        action = :destroy
        description = 'deleted'
      elsif params[:junk].present?
        action = :junk!
        description = 'updated'
      elsif params[:notjunk].present?
        action = :not_junk!
        description = 'updated'
      end
      params[:check].keys.each do |comment_id|
        comment = Comment.find(comment_id)
        if comment.post.user == @current_user
          comment.send(action)
          count += 1
        end
      end
    end
    flash[:notice] = "#{count} comments #{description}" unless count == 0
    flash[:error] = 'No valid comments selected' if count == 0
    redirect_to(admin_comments_path)
  end

  def clear_junk
    comments_ids = Comment.where(:junk => true).map(&:id)
    Comment.delete(comments_ids)
    flash[:notice] = "#{comments_ids.count} junk comment#{comments_ids.count == 1 ? '' : 's'} deleted"
    redirect_to admin_dashboard_index_path
  end

  private
    def check_access(comment, action)
      return true if comment.post.user == @current_user
      flash[:error] = "Can only #{action} comments for your own posts"
      redirect_to(admin_comment_path(comment))
      false
    end

    def comment_param(_params = params)
      _params.require(:comment).permit(:author, :author_email, :author_url, :content, :created_at)
    end
end
