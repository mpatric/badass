class AuthorMailer < ActionMailer::Base
  def new_comment(comment)
    return if comment.post.user.email.blank? || comment.junk?
    @comment = comment
    from_address = APP_CONFIG.email_sender || comment.post.user.email
    title = APP_CONFIG.blog_title || 'blog'
    mail(:from => from_address, :to => comment.post.user.email, :subject => "New comment on #{title}")
  end
end
