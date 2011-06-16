class User < ActiveRecord::Base
  acts_as_authentic
  has_many :posts
  
  scope :has_twitter_name, :conditions => ['twitter_name IS NOT NULL']
  
  def self.can_register?
    APP_CONFIG.max_users.nil? || User.count < APP_CONFIG.max_users
  end
  
  def twitter_url
    return nil if self.twitter_name.blank?
    "http://twitter.com/#{self.twitter_name}"
  end
end
