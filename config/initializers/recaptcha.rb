if defined? APP_CONFIG and APP_CONFIG.recaptcha_enabled and !APP_CONFIG.recaptcha_public_key.blank?
  Recaptcha.configure do |config|
    config.site_key = APP_CONFIG.recaptcha_public_key
    config.secret_key = APP_CONFIG.recaptcha_private_key
  end
end
