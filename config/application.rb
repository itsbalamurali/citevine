require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Citivine
  class Application < Rails::Application

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    config.active_record.whitelist_attributes = true

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # Environment variables
    config.before_configuration do
        env_file = File.join(Rails.root, 'config', 'local_env.yml')
        YAML.load(File.open(env_file)).each do |key, value|
            ENV[key.to_s] = value
        end if File.exists?(env_file)
    end

    # Less
    config.app_generators.stylesheet_engine :less

    # Vine auth URL
    config.vine_api_login_url = "https://api.vineapp.com/users/authenticate"

    # Vine session ID (populated at init)
    config.vine_session_id = nil

    # Vine username (used to fetch session ID)
    config.vine_username = ENV["VINE_USERNAME"]

    # Vine password
    config.vine_password = ENV["VINE_PASSWORD"]

    # Vine main API URL
    config.vine_api_base_url = "https://api.vineapp.com/"

    # Vine CURL User-Agent
    config.vine_user_agent = "com.vine.iphone/1.3.1 (unknown, iPhone OS 5.1.1, iPhone, Scale/2.000000)"
    
    # Vine Accept
    config.vine_accept = "*/*"
    
    # Vine Accept Language
    config.vine_accept_language = "en, sv, fr, de, ja, nl, it, es, pt, pt-PT, da, fi, nb, ko, zh-Hans, zh-Hant, ru, pl, tr, uk, ar, hr, cs, el, he, ro, sk, th, id, ms, en-GB, ca, hu, vi, en-us;q=0.8"

    # Vine default page number
    config.vine_default_page = "1"

    # Vine default items count per page
    config.vine_default_count_items = "20"

    # Vine default items count per page
    config.vine_count_items_options = ["20", "50", "100", "200"]

    config.action_mailer.smtp_settings = {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => "citivine.com",
      :user_name            => ENV["GMAIL_USERNAME"],
      :password             => ENV["GMAIL_PASSWORD"],
      :authentication       => "plain",
      :enable_starttls_auto => true
    }

  end
end