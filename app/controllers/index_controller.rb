require 'json'
require 'curb'

class IndexController < ApplicationController

	include ApplicationHelper

	def initialize
		@@c = curl_init
		super
	end

  	def change_session_size
		session[:size] = params[:size]
		render nothing: true
	end

	def change_session_autoplay
		session[:autoplay] = params[:autoplay]
		render nothing: true
	end

	def change_session_volume
		session[:volume] = params[:volume]
		render nothing: true
	end

	def change_session_autoload
		session[:autoload] = params[:autoload]
		render nothing: true
	end

	def index
		feeds = Array.new;
		[Citivine::Application::config.vine_api_base_url+"timelines/popular"].map do |url|
      		@@c.url = url
			@@c.perform
			feeds = ActiveSupport::JSON.decode(@@c.body_str)
			feeds["data"]["records"].each.with_index do |feed, index|
				user_id = feed["userId"]
				[Citivine::Application::config.vine_api_base_url+'timelines/users/'+user_id.to_s].map do |url|
			      	@@c.url = url
			    	@@c.perform
				    posts = ActiveSupport::JSON.decode(@@c.body_str)
			     	feed["post_count"] = posts["data"]["count"]
			    end
			end
	    end
	    @feeds = feeds
	end

	def about
		render :layout => "application"
	end

	def contact
		@message = Message.new
		render :layout => "application"
	end

	def whatsnew
		render :layout => "application"
	end

	def contact_send
	    @message = Message.new(params[:message])
	    if @message.valid?
	      NotificationsMailer.new_message(@message).deliver
	      redirect_to(contact_path, :notice => "Message was successfully sent. Thanks!")
	    else
	    	if @message.errors[:body]
    			flash.now.alert = @message.errors[:body][0]
    		end
	    	if @message.errors[:email]
	    		flash.now.alert = @message.errors[:email][0]
	    	end
      		render :contact, :layout => "application"
	    end
  	end

end
