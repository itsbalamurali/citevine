require 'json'
require 'curb'

class FeedsController < ApplicationController

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

  def list

    base_url = Citivine::Application::config.vine_api_base_url+'timelines/'+params[:type];

    #Channel ID
    if(params[:id])
      base_url += '/'+params[:id].to_s;
    end

    #Channel type (recent or popular)
    if(params[:subtype])
      base_url += '/'+params[:subtype]
    end

    #Autoload
    if(params[:load])
      page = params[:load]
    else
      page = @@page
    end

    [base_url+'?page='+page+'&size='+session[:size]].map do |url|
      @@c.url = url
      @@c.perform
      @feeds = ActiveSupport::JSON.decode(@@c.body_str)
    end

    if(params[:load])
        render :partial => 'partials/feed_items', :locals => {:feeds => @feeds}, :layout => false, formats: :html;
    end
    
  end

  def test

    ["https://api.vineapp.com/timelines/users/914781099446636544/likes"].map do |url|
      @@c.url = url
      @@c.perform
      @test = ActiveSupport::JSON.decode(@@c.body_str)
    end

  end

  def channels

    [Citivine::Application::config.vine_api_base_url+'timelines/'+params[:type]+'/'+params[:id]+'/'+params[:id]+'?page='+@@page+'&size='+session[:size]].map do |url|
      @@c.url = url
      @@c.perform
      @feeds = ActiveSupport::JSON.decode(@@c.body_str)
    end

  end

  def metas

    if(params[:cat])
      cat = 'timelines/users/'
    else
      cat = 'posts/'
    end

    base_url = Citivine::Application::config.vine_api_base_url+cat+params[:post]+'/'+params[:type]+'?page='+@@page+'&size='+@@size.to_s;
    [base_url].map do |url|
      @@c.url = url
      @@c.perform
      @metas = ActiveSupport::JSON.decode(@@c.body_str)
    end

    render :partial => "partials/"+params[:type], :layout => false, formats: :html

  end

  def metas_more

    metas = Array.new;

    base_url = Citivine::Application::config.vine_api_base_url+'posts/'+params[:post]+'/'+params[:type]+'?page='+@@page+'&size='+@@size.to_s;
    [base_url].map do |url|
      @@c.url = url
      @@c.perform
      metas = ActiveSupport::JSON.decode(@@c.body_str)
    end

    render :partial => "partials/"+params[:type]+"_items", :locals => {:metas => metas}, :layout => false, formats: :html

  end

  def post

    #if(params[:created]) @created = params[:created] end
    #if(params[:description]) @description = params[:description] end
    @videoUrl = params[:videoUrl]
    render :partial => "partials/post", :layout => false, formats: :html

  end

  def search

    users = nil;
    tags = nil;

    base_url = Citivine::Application::config.vine_api_base_url+'users/search/'+URI.escape(params[:request])+'?page='+@@page+'&size='+session[:size];
    [base_url].map do |url|
      @@c.url = url
      @@c.perform
      users = ActiveSupport::JSON.decode(@@c.body_str)
    end

    if(params[:type] && params[:type] == 'users')
      render :partial => "partials/search_users", :locals => {:users => users}, :layout => false, formats: :html
    else
      @feeds = users;
    end

    base_url = Citivine::Application::config.vine_api_base_url+'tags/search/'+URI.escape(params[:request])+'?page='+@@page+'&size='+session[:size];
    [base_url].map do |url|
      @@c.url = url
      @@c.perform
      tags = ActiveSupport::JSON.decode(@@c.body_str)
    end

    if(params[:type] && params[:type] == 'tags')
      render :partial => "partials/search_tags", :locals => {:tags => tags}, :layout => false, formats: :html
    else
      @tags = tags;
    end

  end

end
