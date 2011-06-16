require "#{File.dirname(__FILE__)}/migrations_generator"
require "#{File.dirname(__FILE__)}/assets_generator"

module Badass
  class SiteGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    
    source_root File.expand_path('../templates/site', __FILE__)
    
    def generate_site
      @name = File.basename(destination_root).gsub(/[-| ]/, '_')
      
      Badass::MigrationsGenerator.new([], @options).generate_migrations
      Badass::AssetsGenerator.new([], @options).regenerate
      
      template 'config/badass.rb', 'config/badass.yml'
      template 'config/database.rb', 'config/database.yml'
      template 'config/s3.rb', 'config/s3.yml'
      
      directory 'app', 'app'
      
      remove_file 'public/index.html'
    end
  end
end
