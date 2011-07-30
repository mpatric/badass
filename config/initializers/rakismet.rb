if defined? APP_CONFIG and APP_CONFIG.akismet_enabled and !APP_CONFIG.akismet_api_key.blank?
  Rakismet::KEY = APP_CONFIG.akismet_api_key
  Rakismet::URL = APP_CONFIG.domain
  Rakismet::HOST = 'rest.akismet.com'
end
