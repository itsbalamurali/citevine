require 'json'
require 'curb'
require 'nokogiri'
require 'open-uri'

class ApplicationController < ActionController::Base
  
    protect_from_forgery
    before_filter :auth, :set_session_size, :set_session_autoplay, :set_session_volume, :set_session_autoload, :get_trending_tags, :get_avatars, :get_channels

    def initialize
      @@c = curl_init
      @@trending_tags = Array.new;
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
    vine_home = Nokogiri::HTML(open('https://vine.co/explore'))
    vine_home.css('section#trending a').each do |tag|
    @@trending_tags.push(tag.content);
        end
        @trending_tags = @@trending_tags;

    end	

    def get_channels
      channels = Array.new;
      vine_home = Nokogiri::HTML(open('https://vine.co/explore/v2'))
      vine_home.css('section#channels a').each do |tag|
        channels.push(tag.content);
      end
      @channels = channels;

    end

    def get_avatars
        #avatars = Array.new;
        #[Citivine::Application::config.vine_api_base_url+"timelines/popular?page=1&size=100"].map do |url|
            #c.url = url
            #c.perform
            #avatars.push(ActiveSupport::JSON.decode(c.body_str));
	  	#end
        #[Citivine::Application::config.vine_api_base_url+"timelines/popular?page=2&size=100"].map do |url|
            #c.url = url
            #c.perform
            #avatars.push(ActiveSupport::JSON.decode(c.body_str));
        #end
        #@avatars = avatars;
    end
end
