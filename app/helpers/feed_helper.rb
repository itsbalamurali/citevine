require 'curb'

module FeedHelper

	def check_from_exists(location)
		if location != nil && location.to_s.length > 0
			true
		else 
			false;
		end
	end

	def check_description_exists(description)
		if description.length > 0 
			true 
		else 
			false;
		end
	end

	def format_large_number(number)
		number_to_human(number.to_i, 
			:precision => 2,
			:signficant => false,
			:units => {
				:unit => '',
				:thousand => 'k', 
				:million => 'm',
				:billion => 'b'
			},
			:format => '%n%u'
		)
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

  	def auto_tag_vine(txt, options = {})
	    txt.scan(/(^|\W|\s+)(#|@)(\w{1,25})/).each do |match|
	  		if match[1] == "#"
		        txt.gsub!(/##{match.last}/, link_to("##{match.last}", tag_path(:tag => "#{match.last}"), options))
	      	end
		end
    	txt
  	end

  	def format_date(date)
  		diff_to_now = (Time.now - date.to_time).to_f
  		if diff_to_now/60 < 1
			gap = diff_to_now.to_i.to_s
			gap += (diff_to_now.to_i/60 > 1) ? ' seconds' : ' seconds'
  		elsif diff_to_now/60 > 1 && diff_to_now/3600 < 1
  			gap = (diff_to_now.to_i/60).to_s
  			gap += (diff_to_now.to_i/60 > 1) ? ' minutes' : ' minute'
  		elsif diff_to_now/3600 > 1 && diff_to_now/86400 < 1
  			gap = (diff_to_now.to_i/3600).to_s
  			gap += (diff_to_now.to_i/3600 > 1) ? ' hours' : ' hour'
		else
			gap = (diff_to_now.to_i/86400).to_s
			gap += (diff_to_now.to_i/86400 > 1) ? ' days' : ' day'
		end
  		gap
  	end

end
