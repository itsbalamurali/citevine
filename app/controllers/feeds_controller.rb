require 'json'
require 'curb'

class FeedsController < ApplicationController

  protect_from_forgery
  include ApplicationHelper
  before_filter :init_params

  def initialize
    @@c = curl_init
    @@page = Citivine::Application::config.vine_default_page
    @@size = Citivine::Application::config.vine_default_count_items
    super
  end

  def init_params
    if(params[:page])
      @@page = params[:page]
    end
  end

  def list

    base_url = Citivine::Application::config.vine_api_base_url+'timelines/'+params[:type]

    #Channel ID
    if(params[:id])
      base_url += '/'+params[:id].to_s
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
        render :partial => 'partials/feed_items', :locals => {:feeds => @feeds}, :layout => false, formats: :html
    end
    
  end

  def post

    userId = nil;
    base_url = Citivine::Application::config.vine_api_base_url+'timelines/posts/'+params[:post]
    [base_url].map do |url|
      @@c.url = url
      @@c.perform
      @post = ActiveSupport::JSON.decode(@@c.body_str)
      @post["data"]["records"].each.with_index do |post, index|
        userId = post["userId"]
      end
    end

    [Citivine::Application::config.vine_api_base_url+'timelines/users/'+userId.to_s].map do |url|
      @@c.url = url
      @@c.perform
      @feeds = ActiveSupport::JSON.decode(@@c.body_str)
    end

    @comments = metas(:post => params[:post], :type => "comments")
    @likes = metas(:post => params[:post], :type => "likes")

    #popup
    if request.referer != nil && URI(request.referer).path != '/'
      render :partial => "partials/post_popup", :layout => false, formats: :html
    end

  end

  def test

    ['https://api.vineapp.com/timelines/venues/1010405498111336448'].map do |url|
      @@c.url = url
      @@c.perform
      @test = ActiveSupport::JSON.decode(@@c.body_str)
    end

  end

  def channels

    base_url = Citivine::Application::config.vine_api_base_url+'timelines/'+params[:type]+'/'+params[:id]+'/'+params[:id]+'?page='+@@page+'&size='+session[:size]
    [base_url].map do |url|
      @@c.url = url
      @@c.perform
      @feeds = ActiveSupport::JSON.decode(@@c.body_str)
    end

  end

  def metas params = {}

    if(params[:cat])
      cat = 'timelines/users/'
    else
      cat = 'posts/'
    end

    metas = Array.new;

    base_url = Citivine::Application::config.vine_api_base_url+cat+params[:post]+'/'+params[:type]+'?page='+@@page+'&size='+@@size.to_s
    [base_url].map do |url|
      @@c.url = url
      @@c.perform
      metas = ActiveSupport::JSON.decode(@@c.body_str)
    end

    return metas
    render nothing: true

  end

  def metas_more

    metas = Array.new;

    base_url = Citivine::Application::config.vine_api_base_url+'posts/'+params[:post]+'/'+params[:type]+'?page='+params[:page]+'&size='+@@size.to_s;
    [base_url].map do |url|
      @@c.url = url
      @@c.perform
      metas = ActiveSupport::JSON.decode(@@c.body_str)
    end

    render :partial => "partials/"+params[:type]+"_items", :locals => {:metas => metas, :post => params[:post]}, :layout => false, formats: :html

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

  def tag
    
    auth
    c = curl_init

    page = Citivine::Application::config.vine_default_page;

    #Autoload
    if(params[:load])
      page = params[:load]
    else
      page = @@page
    end

    [Citivine::Application::config.vine_api_base_url+'timelines/tags/'+params[:tag]+'?page='+page+'&size='+session[:size]].map do |url|
      c.url = url
      c.perform
      @feeds = ActiveSupport::JSON.decode(c.body_str)
    end

    if(params[:load])
      render :partial => 'partials/feed_items', :locals => {:feeds => @feeds}, :layout => false, formats: :html
    else
      render :template => 'feeds/list'
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
