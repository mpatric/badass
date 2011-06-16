module PostsHelper
  def posted_or_updated_at_with_author(post)
    return nil if !post.published?
    tagline = updated_at(post, true)
    tagline ||= posted_at(post, true)
    tagline += posted_by(post).to_s
    tagline
  end
  
  def posted_at(post, capitalize=true)
    if post.published?
      posted = 'posted'
      posted.capitalize! if capitalize
      "#{posted} #{format_timestamp_relative(post.first_published_at)}"
    end
  end
  
  def updated_at(post, capitalize=true)
    if post.last_published_at != post.first_published_at
      updated = 'updated'
      updated.capitalize! if capitalize
      "#{updated} #{format_timestamp_relative(post.last_published_at)}"
    end
  end
  
  def posted_by(post)
    " by #{post.user.name}" unless post.user.nil? or post.user.name.blank?
  end
  
  def posted_in_tags(post)
    return nil if post.tags.empty?
    tags = post.tags.by_label.collect do |tag|
      link_to(tag.label, tag.permalink_url)
    end
    ((tags.count == 1 ? 'Tag: ' : 'Tags: ') + tags.join(', ')).html_safe
  end
end
