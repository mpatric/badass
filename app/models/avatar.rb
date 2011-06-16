require 'gravatar'

class Avatar
  NO_AVATAR_PATH = "/images/noavatar.png"
  
  def self.avatar_url(email, default_host, default_port)
    unless email.blank?
      return Gravatar.new(email, make_gravatar_options(default_host, default_port)).url
    end
    return "http://#{default_host}#{NO_AVATAR_PATH}".html_safe
  end
  
  def self.make_gravatar_options(default_host, default_port)
    options = {:size => 32}
    if default_host
      default_url = "http://#{default_host}"
      default_url = default_url + ":#{default_port}" if default_port and default_port != 80
      default_url = default_url + NO_AVATAR_PATH
      options[:default] = default_url
    end      
    options
  end
end
