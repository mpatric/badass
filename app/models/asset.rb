class Asset < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :title
  validate :file_does_not_exist
  validates_attachment_presence :upload
  
  has_attached_file :upload, :styles => { :thumb => "100x100>" }, :path => "/assets/:style/:basename.:extension",
                    :storage => :s3, :s3_credentials => "#{::Rails.root}/config/s3.yml"
  
  before_post_process :is_image?
  
  scope :by_date_descending, :order => 'upload_updated_at DESC'
  
  DEFAULT_THUMBNAIL_URL = '/images/file.png'
  
  def is_image?
    !(upload_content_type =~ /^image.*/).nil?
  end
  
  def url
    self.upload.url
  end
  
  def thumbnail_url
    if is_image?
      self.upload.url(:thumb)
    else
      DEFAULT_THUMBNAIL_URL
    end
  end
  
  private
    def file_does_not_exist
      Asset.find_all_by_upload_file_name(self.upload_file_name).each do |asset|
        next if asset.id = self.id
        errors.add_to_base("File named #{self.upload_file_name} already exists")
        return
      end
    end
end
