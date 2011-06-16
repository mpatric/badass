require 'badass'
require 'rails'
require 'mysql2'
require 'authlogic'
require 'bluecloth'
require 'will_paginate'
require 'gravatar'
require 'rakismet'
require 'haml'
require 'paperclip'
require 'grackle'
require 'aws/s3'

module Badass
  class Engine < Rails::Engine
    config.action_mailer.smtp_settings = { :enable_starttls_auto => false }
    initializer 'badass.load_config', :after => :load_config_initializers do |app|
      CSS_PATH = File.expand_path(File.join(Rails.root, %w[public stylesheets]))
      SASS_PATH = File.join(File.dirname(__FILE__), *%w[.. .. public stylesheets sass])
      ::Sass::Plugin.add_template_location(SASS_PATH, CSS_PATH)
      ActionView::Base.send :include, BadassHelper
    end
  end
end