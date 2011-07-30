class Tag < ActiveRecord::Base
  has_many :posts_tags
  has_many :posts, :through => :posts_tags
  
  before_validation :generate_permalink
  
  validate :check_permalink
  validates_uniqueness_of :permalink, :label
  validates_presence_of :label
  
  scope :by_label, :order => :label
  scope :with_posts, :joins => ['JOIN posts_tags pt ON pt.tag_id = tags.id']
  scope :with_published_posts, :joins => ['JOIN posts_tags pt ON pt.tag_id = tags.id', 'JOIN posts p ON p.id = pt.post_id'], :conditions => ['p.version IS NOT NULL']
  
  def permalink_url
    "/tag/#{self.permalink}"
  end
  
  private
    def generate_permalink
      return unless self.permalink.blank?
      return if self.label.nil?
      self.permalink = "#{label.downcase.gsub(/[^A-Za-z0-9 ]/, '').gsub(' ', '-')}"
    end
    
    def check_permalink
      unless self.permalink.match(/^([a-zA-Z0-9]|-)*$/)
        errors.add(:permalink, "can only contain alphanumerics and dashes")
      end
    end
end
