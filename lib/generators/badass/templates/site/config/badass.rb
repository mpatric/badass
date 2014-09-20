common:
  domain: '<%= @name.gsub('_', '') %>.com'
  blog_title: '<%= @name.humanize %>'
  blog_description: 'TODO'
  keywords: 'TODO'
  posts_per_page: 5
  posts_in_feed: 50
  comments_in_feed: 250
  email_enabled: false
  email_sender: 'noreply@<%= @name.gsub('_', '') %>.com'
  akismet_enabled: false
  akismet_api_key:
  twitter_enabled: true
  twitter_cache_time: 600
  facebook_enabled: true
  google_analytics_enabled: false
  google_analytics_id:
  google_site_verification:
  max_users: 5
  comments_disabled: true
  jquery_lib: 'jquery-1.4.4.js'
  recaptcha_enabled: true
  recaptcha_public_key:
  recaptcha_private_key:

development:
  domain: 'localhost:3000'
  google_analytics_enabled: false

test:

production:
  email_enabled: true
  akismet_enabled: true
  max_users: 1
  jquery_lib: 'jquery-1.4.4.min.js'
