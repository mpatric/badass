common:
  domain: '<%= @name.gsub('_', '') %>.com'
  blog_title: '<%= @name.humanize %>'
  blog_description: 'TODO'
  keywords: 'TODO'
  posts_per_page: 5
  posts_in_feed: 50
  comments_in_feed: 250
  email_enabled: true
  akismet_enabled: false
  akismet_api_key:
  twitter_enabled: true
  twitter_cache_time: 600
  google_analytics_enabled: false
  google_analytics_id:
  max_users: 5
  jquery_lib: 'jquery-1.4.4.js'

development:
  domain: 'localhost:3000'
  google_analytics_enabled: false

test:

production:
  akismet_enabled: true
  max_users: 1
  jquery_lib: 'jquery-1.4.4.min.js'
