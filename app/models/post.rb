class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :dependent => :destroy
  has_many :posts_tags
  has_many :tags, :through => :posts_tags
  
  before_validation :generate_permalink
  
  validate :check_permalink
  validates_uniqueness_of :permalink
  validates_presence_of :title_draft, :date
  
  scope :by_date_descending, :order => 'date DESC'
  scope :by_last_published, :order => 'last_published_at DESC'
  scope :published, :conditions => 'version IS NOT NULL'
  scope :unpublished, :conditions => 'version IS NULL'
  scope :outdated, :conditions => 'version IS NOT NULL AND version != version_draft'
  scope :current, :conditions => 'version IS NOT NULL AND version = version_draft'
  scope :for_author, lambda { |user| {:conditions => {:user_id => user.id} }}
  scope :with_tag, lambda { |tag| {:joins => ['JOIN posts_tags pt ON pt.post_id = posts.id'], :conditions => ['pt.tag_id = ?', tag.id]} }
  scope :since, lambda { |date| {:conditions => ['last_published_at > ?', date] }}
  
  INVALID_PERMALINKS = ['admin', 'register', 'login', 'logout', 'posts', 'comments', 'tag']
  
  def content_draft_html
    markdown(content_draft.gsub('~', ' '))
  end
  
  def content_html
    markdown(content.gsub('~', ' '))
  end
  
  def content_short_html(more_label=nil)
    return nil if self.content.nil?
    return content_html unless content_shortened?
    markdown(self.content.split('~')[0] + "#{more_label}")
  end
  
  def content_shortened?
    !self.content.nil? and self.content.include?('~')
  end
  
  def status
    return :unpublished if self.version.blank?
    return :outdated if self.version_draft != self.version
    :current
  end
  
  def published?
    !version.blank?
  end
  
  def permalink_url
    self.published? ? "/#{self.permalink}" : nil
  end
  
  def full_permalink_url
    permalink_url ? "http://#{File.join(APP_CONFIG.domain, permalink_url)}" : nil
  end
  
  def preview_url
    "/#{self.permalink}/preview"
  end
  
  def avatar_url(default_host=nil, default_port=nil)
    Avatar.avatar_url(self.user.email, default_host, default_port)
  end
  
  def publish!(quiet=false)
    self.title = self.title_draft
    self.content = self.content_draft
    self.version = self.version_draft
    now = Time.now
    self.first_published_at = now if self.first_published_at.nil?
    self.last_published_at = now if self.last_published_at.nil? or !quiet
    true
  end
  
  def change_to_bump_version?
    self.changed? and (self.content_draft_changed? or self.title_draft_changed?)
  end
  
  private
    def generate_permalink
      return unless self.permalink.blank?
      return if self.date.blank? or self.title_draft.blank?
      self.permalink = "#{self.date.strftime('%Y-%m-%d')}-#{title_draft.downcase.gsub(/[^A-Za-z0-9 \-]/, '').gsub(/( |-)+/, '-')}"
    end
    
    def check_permalink
      unless self.permalink.match(/^([a-zA-Z0-9]|-)*$/)
        errors.add(:permalink, "can only contain alphanumerics and dashes")
      else
        errors.add(:permalink, "can not be the same as a system path") if INVALID_PERMALINKS.include?(self.permalink.downcase)
      end
    end
    
    def markdown(s)
      BlueCloth.new(keep_linebreaks(s)).to_html.html_safe
    end
    
    def keep_linebreaks(s)
      s.gsub("\r\n", "\n").gsub("\r", "\n").gsub("\n\n", "\r\r").gsub("\n", "  \n").gsub("\r\r", "\n\n")
    end
end
