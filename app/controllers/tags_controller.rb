require 'json'
require 'curb'

class TagsController < ApplicationController

  include ApplicationHelper

  def tag
    
    auth
    c = curl_init

    page = Citivine::Application::config.vine_default_page;

    if(params[:page])
      page = params[:page]
    end

    [Citivine::Application::config.vine_api_base_url+'timelines/tags/'+params[:tag]+'?page='+page+'&size='+session[:size]].map do |url|
      c.url = url
      c.perform
      @feeds = ActiveSupport::JSON.decode(c.body_str)
    end

    render :template => 'feeds/list'

  end

end
