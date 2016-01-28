if defined? APP_CONFIG and APP_CONFIG.akismet_enabled and !APP_CONFIG.akismet_api_key.blank?
  rakismet_config = Rails.application.config.rakismet
  rakismet_config.key = APP_CONFIG.akismet_api_key
  rakismet_config.url = APP_CONFIG.domain
end
