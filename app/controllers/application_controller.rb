require 'json'
require 'curb'
require 'open-uri'

class ApplicationController < ActionController::Base
  
	protect_from_forgery
	before_filter :auth, :set_session_size, :set_session_autoplay, :set_session_volume, :set_session_autoload, :get_trending_tags, :get_channels

    def initialize
      @@c = curl_init
      @controller = controller_name
      @action = action_name
      @@trending_tags = Array.new;
      @@channels = Array.new;
      super
    end

    def auth
      auth
    end

    def set_session_size
    	session[:size] ||= Citivine::Application::config.vine_default_count_items
  	end

    def set_session_autoplay
      session[:autoplay] ||= '1';
    end

    def set_session_volume
      session[:volume] ||= '5';
    end

    def set_session_autoload
      session[:autoload] ||= '1';
    end

  	def get_trending_tags
      base_url = Citivine::Application::config.vine_api_base_url+'tags/trending';
      [base_url].map do |url|
        @@c.url = url
        @@c.perform
        @@trending_tags = ActiveSupport::JSON.decode(@@c.body_str)
      end
	    @trending_tags = @@trending_tags;
  	end	

    def get_channels
      base_url = Citivine::Application::config.vine_api_base_url+'channels/featured';
      [base_url].map do |url|
        @@c.url = url
        @@c.perform
        @@channels = ActiveSupport::JSON.decode(@@c.body_str)
      end
      @channels = @@channels;
    end

end
