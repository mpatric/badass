module BadassHelper
  include CommentsHelper
  include HomeHelper
  include PostsHelper

  if defined? APP_CONFIG and APP_CONFIG.recaptcha_enabled and !APP_CONFIG.recaptcha_public_key.blank?
    include Recaptcha::ClientHelper
  end
  
  def format_timestamp(ts, separator=', ')
    return '' unless ts.respond_to?(:strftime)
    ts.strftime("%a %d %b %Y#{separator}%H:%M:%S").html_safe
  end
  
  def format_timestamp_relative(ts)
    return time_ago_in_words(ts, true) + ' ago' if ts > 7.days.ago
    ts.strftime('%a %d %b %Y')
  end
  
  def format_date(d)
    return '' unless d.respond_to?(:strftime)
    d.strftime('%a %d %b %Y')
  end
  
  def format_with_linebreaks(t)
    return '' if t.blank?
    h(t).gsub("\n", "<br/>\n")
  end
  
  def button(link, title, method='get', options={})
    btn = button_to(title, link, options.merge(:method => method))
    "<div class='button'>#{btn}</div>".html_safe
  end
  
  def button_with_confirmation(link, title, message='Are you sure?', method='get')
    btn = button_to(title, link, :class => 'must-confirm', :message => message, :method => method)
    "<div class='button'>#{btn}</div>".html_safe
  end
  
  def truncate_string(s, length)
    s[0..length] + (s.length > length ? '...' : '')
  end
  
  def options_from_hash(h)
    h.collect do |k,v|
      "<option value='#{k}'>#{v}</option>"
    end
  end
  
  def keywords(post=nil)
    if post.nil? or post.tags.empty?
      APP_CONFIG.keywords
    else
      APP_CONFIG.keywords + ", " + @post.tags.collect(&:label).join(', ')
    end
  end
  
  def posts_feed_url(tag=nil)
    return "http://#{host}/posts.atom" if tag.nil?
    "http://#{host}/#{tag.permalink}/posts.atom"
  end
  
  def comments_feed_url(post=nil)
    return "http://#{host}/comments.atom" if post.nil?
    "http://#{host}/#{post.permalink}/comments.atom"
  end
  
  def posts_feed_title(tag=nil)
    return "Posts feed" if tag.nil?
    "Posts feed (#{tag.label})"
  end
  
  def comments_feed_title(post=nil)
    return "Comments feed" if post.nil?
    "Comments feed (#{post.title})"
  end

  def recaptcha_enabled?
    defined? APP_CONFIG and APP_CONFIG.recaptcha_enabled and !APP_CONFIG.recaptcha_public_key.blank?
  end
end