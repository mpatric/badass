module CommentsHelper
  def comment_count_description(post)
    not_junk_count = post.comments.not_junk.count
    return '1 comment' if not_junk_count == 1
    "#{not_junk_count} comments"
  end
  
  def comment_count_link(post)
    not_junk_count = post.comments.not_junk.count
    junk_count = post.comments.junk.count
    description = [not_junk_count.to_s, junk_count.to_s].join(' + ')
    post.comments.count == 0 ? '0' : link_to("#{description}", admin_comments_path(:post_id => post.id))
  end
end
