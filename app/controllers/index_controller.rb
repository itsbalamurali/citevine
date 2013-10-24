require 'json'
require 'curb'
require 'nokogiri'
require 'open-uri'

class IndexController < ApplicationController

  include ApplicationHelper

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
		if params[:item]
			tag_number = params[:item].to_i
			#tag_number = rand(0..@@trending_tags.length)
			tag = @@trending_tags[tag_number]
			tag = tag.strip[1..tag.length-1]

			[Citivine::Application::config.vine_api_base_url+'timelines/tags/'+tag+'?page=1&size=1'].map do |url|
		      @@c.url = url
		      @@c.perform
		      @feed = ActiveSupport::JSON.decode(@@c.body_str)
		    end
		    render :partial => "partials/index_bubble", :layout => false, formats: :html
		end
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
