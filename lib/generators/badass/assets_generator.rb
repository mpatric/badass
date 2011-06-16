module Badass
  class AssetsGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates/assets', __FILE__)
    
    def regenerate
      directory 'images', 'public/images'
      directory 'javascripts', 'public/javascripts'
      directory 'stylesheets', 'public/stylesheets'
      directory 'markitup', 'public/markitup'
      copy_file 'favicon.ico', 'public/favicon.ico'
    end
  end
end
