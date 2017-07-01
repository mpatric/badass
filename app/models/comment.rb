class Comment < ActiveRecord::Base
  include Rakismet::Model
  
  belongs_to :post
  
  validate :check_mandatory_fields
  validates_presence_of :author, :author_email, :content, :on => :update
  
  scope :by_date_descending, :order => 'created_at DESC'
  scope :by_date_ascending, :order => 'created_at'
  scope :for_post, lambda { |post| {:conditions => ['post_id = ?', post.id] }}
  scope :for_published_posts, :joins => ['JOIN posts p ON p.id = comments.post_id'], :conditions => 'version IS NOT NULL'
  scope :for_author, lambda { |user| {:joins => ['JOIN posts p ON comments.post_id = p.id'], :conditions => ['p.user_id = ?', user.id] }}
  scope :not_junk, :conditions => {:junk => false}
  scope :junk, :conditions => {:junk => true}
  scope :with_tag, lambda { |tag| {
    :joins => ['JOIN posts p ON p.id = comments.post_id', 'JOIN posts_tags pt ON pt.post_id = p.id'],
    :conditions => ['pt.tag_id = ?', tag.id] }}
  scope :since, lambda { |date| {:conditions => ['created_at > ?', date] }}
  
  before_create :check_for_spam

  attr_accessor :recaptcha_failed

  def content_html
    markdown(self.content)
  end
  
  def content_text
    Nokogiri::HTML(content_html).xpath("//text()").text
  end
  
  def permalink
    "#{self.post.permalink}##{self.id}"
  end
  
  def permalink_url
    self.post.permalink_url ? "#{self.post.permalink_url}##{self.id}" : nil
  end
  
  def full_permalink_url
    permalink_url ? "http://#{File.join(APP_CONFIG.domain, permalink_url)}" : nil
  end
  
  def avatar_url(default_host=nil, default_port=nil)
    Avatar.avatar_url(self.author_email, default_host, default_port)
  end
  
  def junk!
    unless self.junk?
      self.spam! if using_askimet?
      self.junk = true
      self.save
    end
  end
  
  def not_junk!
    if self.junk?
      self.ham! if using_askimet?
      self.junk = false
      self.save
    end
  end
  
  private
    def check_mandatory_fields
      return unless self.new_record?
      missing = []
      missing << 'your name' if self.author.blank?
      missing << 'your email address' if self.author_email.blank?
      missing << 'your comment' if self.content.blank?
      missing_message = if missing.size > 0
        "Please fill in " + (missing.size == 1 ? message = missing.first : missing[0..-2].join(', ') + ' and ' + missing[-1])
      else
        nil
      end

      if recaptcha_failed
        message = (missing_message.blank? ? "Please" : "#{missing_message} and") + " confirm you're not a robot"
      else
        message = missing_message
      end

      errors[:base] << message unless message.blank?
    end

    def check_for_spam
      self.junk = true if using_askimet? and self.spam?
    end

    def using_askimet?
      APP_CONFIG.akismet_enabled and !APP_CONFIG.akismet_api_key.blank?
    end

    def markdown(s)
      BlueCloth.new(keep_linebreaks(s)).to_html.html_safe
    end

    def keep_linebreaks(s)
      s.gsub("\r\n", "\n").gsub("\r", "\n").gsub("\n\n", "\r\r").gsub("\n", "  \n").gsub("\r\r", "\n\n")
    end
end
