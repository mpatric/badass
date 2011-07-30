# default action mailer config - can be over-ridden in application.rb or environments/*
if defined? APP_CONFIG and APP_CONFIG.email_enabled
  am_config = Rails.application.config.action_mailer
  am_config.perform_deliveries = true if am_config.perform_deliveries.nil?
  am_config.raise_delivery_errors = true if am_config.raise_delivery_errors.nil?
  am_config.default_charset ||= "utf-8"
  am_config.delivery_method ||= :smtp
  am_config.smtp_settings[:enable_starttls_auto] = true if am_config.smtp_settings[:enable_starttls_auto].nil?
  am_config.smtp_settings[:authentication] ||= :plain
  am_config.smtp_settings[:tls] = true if am_config.smtp_settings[:tls].nil?
end