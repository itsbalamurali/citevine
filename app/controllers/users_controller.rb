require 'json'
require 'curb'

class UsersController < ApplicationController

  protect_from_forgery
  include ApplicationHelper
  before_filter :init_params

  def initialize
    @@c = curl_init
    @@page = Citivine::Application::config.vine_default_page;
    @@size = Citivine::Application::config.vine_default_count_items;
    super
  end

  def init_params
    if(params[:page])
      @@page = params[:page]
    end
  end

  def user

    if(params[:load])
      page = params[:load]
    else
      page = @@page
    end
    
    [Citivine::Application::config.vine_api_base_url+'users/profiles/'+params[:user]].map do |url|
      @@c.url = url
      @@c.perform
      user = ActiveSupport::JSON.decode(@@c.body_str)
      @user = user["data"]
    end

    [Citivine::Application::config.vine_api_base_url+'timelines/users/'+params[:user]+'?page='+page+'&size='+session[:size]].map do |url|
      @@c.url = url
      @@c.perform
      @feeds = ActiveSupport::JSON.decode(@@c.body_str)
    end

    if(params[:load])
        render :partial => 'partials/feed_items', :locals => {:feeds => @feeds}, :layout => false, formats: :html;
    end

  end

end
