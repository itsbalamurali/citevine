require 'curb'

module ApplicationHelper

	def curl_init
		c = Curl::Easy.new
		c.http_auth_types = :basic
		c.headers["user-agent"] = Citivine::Application::config.vine_user_agent
	    c.headers["vine-session-id"] = Citivine::Application::config.vine_session_id
	    c.headers["accept"] = Citivine::Application::config.vine_accept
	    c.headers["accept-language"] = Citivine::Application::config.vine_accept_language
	    return c
	end

	def auth
		# Run Vine auth if session id is not defined
  		return Citivine::Application.config.vine_session_id if Citivine::Application.config.vine_session_id
		c = Curl::Easy.new(Citivine::Application::config.vine_api_login_url)
		c.http_auth_types = :basic
		c.http_post(
		    Curl::PostField.content('username', Citivine::Application::config.vine_username), 
		    Curl::PostField.content('password', Citivine::Application::config.vine_password)) do |curl| 
				curl.headers["user-agent"] = Citivine::Application::config.vine_user_agent
				curl.headers["accept"] = Citivine::Application::config.vine_accept
				curl.headers["accept-language"] = Citivine::Application::config.vine_accept_language
				curl.headers["accept-encoding"] = "gzip"
	    	end
    	auth = ActiveSupport::JSON.decode(c.body_str)
    	Citivine::Application.config.vine_session_id = auth["data"]["key"]
	end

	def nav_links
	    items = [home_link, popular_link, promoted_link, tags_link]
	    content_tag :ul, :class => "nav" do
      		items.collect { |item| concat item}
    	end
  	end

  	def home_link
	    nav_item_active_if() do
     		link_to "Home", root_path
	    end
  	end

  	def popular_link
	    nav_item_active_if() do
     		link_to "Popular", list_path(:type => :popular)
	    end
  	end

  	def promoted_link
	    nav_item_active_if() do
     		link_to "Promoted", list_path(:type => :promoted)
	    end
  	end

  	def tags_link
	    nav_item_active_if() do
     		link_to "Tags", list_path(:type => :tags, :tag => :magic)
	    end
  	end

  	def nav_item_active_if(attributes = {}, &block)
  		attributes["class"] = ""
	    content_tag(:li, attributes, &block)
  	end

 	def auto_link_twitter(txt, options = {:target => "_blank"})
	    txt.scan(/(^|\W|\s+)(#|@)(\w{1,25})/).each do |match|
	  		if match[1] == "#"
		        txt.gsub!(/##{match.last}/, link_to("##{match.last}", "//twitter.com/search/?q=##{match.last}", options))
	    	elsif match[1] == "@"
		          	txt.gsub!(/@#{match.last}/, link_to("@#{match.last}", "//twitter.com/#{match.last}", options))
	      	end
		end
    	txt
  	end

end
