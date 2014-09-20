require 'badass'
require 'rails'
require 'mysql2'
require 'authlogic'
require 'bluecloth'
require 'will_paginate'
require 'gravatar'
require 'rakismet'
require 'sass'
require 'haml'
require 'paperclip'
require 'grackle'
require 'aws/s3'
require 'nokogiri'
require 'rack/recaptcha'

module Badass
  class Engine < Rails::Engine
    initializer 'badass.add_middleware' do |app|
      if defined? APP_CONFIG and APP_CONFIG.recaptcha_enabled and !APP_CONFIG.recaptcha_public_key.blank?
        app.gem 'rack-recaptcha', :lib => 'rack/recaptcha'
        app.middleware.use Rack::Recaptcha, :public_key => APP_CONFIG.recaptcha_public_key, :private_key => APP_CONFIG.recaptcha_private_key
      end
    end
    initializer 'badass.load_config', :after => :load_config_initializers do |app|
      CSS_PATH = File.expand_path(File.join(Rails.root, %w[public stylesheets]))
      SASS_PATH = File.join(File.dirname(__FILE__), *%w[.. .. public stylesheets sass])
      ::Sass::Plugin.add_template_location(SASS_PATH, CSS_PATH)
      ActionView::Base.send :include, BadassHelper
    end
    config.action_mailer.smtp_settings ||= {}
  end
end