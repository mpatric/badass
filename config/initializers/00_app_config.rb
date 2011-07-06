config_file = YAML.load_file("#{Rails.root}/config/badass.yml") rescue nil
if config_file
  app_config = config_file['common'] || {}
  app_config.update(config_file[ENV["RAILS_ENV"]] || {}) if ENV["RAILS_ENV"]
  APP_CONFIG = OpenStruct.new(app_config)
end