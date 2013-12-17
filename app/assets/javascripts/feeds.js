$(document).ready(function() {

	var player;
	var ex_volume = volume;
	$('#list_avatars_container').css('width', $('#list_avatars_container li').length*90+'px');

	/**
	 * Bindings video event
	 */
	var video_binder = function(id, popup){
 		var videoPlaying = false;
 		videojs(id, {
			'controls': false
		}).ready(function(){
	  		player = this;
	  		player.volume(volume);
	  		if(volume > 0) {
	  			$('.mute-button').removeClass('off').addClass('on');
	  		} else {
	  			$('.mute-button').removeClass('on').addClass('off');
	  		}
	  		$('video').click(function(){
	  			if(videoPlaying) {
	  				player.pause();
	  				videoPlaying = false;
	  			} else {
					player.play();
					videoPlaying = true;
	  			}
	  			return false;
	  		});
	  		$('.mute-button').click(function() {
				//put on
				if (player.volume() == 0) {
					$(this).removeClass('off');
					$(this).addClass('on');
					volume = ex_volume;
				//put off
				} else {
					$(this).removeClass('on');
					$(this).addClass('off');
					volume = 0;
				}
				$('#settings_dropdown #slider').slider('value', volume*10);
				player.volume(volume);
				return false;
			});
			if(popup) {
				$('div#'+id).css({
					height: 'auto'
				});
				if(autoplay == '1') {
		  			player.play();
		  			videoPlaying = true;
		  		}
			}
		});
	}

	/**
	 * Bindings metas post
	 */
 	var metas_binder = function(){
		/**
		 * Tabs popup post
		 */
		$('#metas_cont .nav-tabs a').click(function(){
			var toggle = $(this).parent().attr('class');
			if($(this).parent().hasClass('active')) return false;
			$('#metas_cont .nav-tabs li').removeClass('active');
			$(this).parent().addClass('active');
			$('#metas_cont ul.metas:visible').fadeOut('20', function(){
				$('#metas_cont ul#'+toggle).fadeIn('20');	
			});
			return false;
		});

		/**
		 * More comments & likes
		 */
	 	$('#metas_cont ul').on('click', '.search_more_metas', function(){
 			var link = $(this);
			$.ajax({
				url: link.attr('href'),
				beforeSend:function() {
					link.find('i').removeClass('icon-plus').addClass('icon-repeat');
				},
				success:function(datas){
					link.before(datas).remove();
				},
				error:function(){
				},
				complete: function() {
					link.find('i').removeClass('icon-repeat').addClass('icon-plus');
				}

			});
			return false;
	 	});

	 	/**
		 * Share url
		 */
	 	$('#metas_cont input').click(function(){
	 		$(this).select();
	 	});
	}

	/**
	 * Double trigger popup post
	 */
 	if($(window).width() > 980) {
		$('.feeds_list').on('click', '.open-video-popup-alt', function() {
			$('.open-video-popup[href="'+$(this).attr('href')+'"]').trigger('click');
			return false;
		});
	}

	/**
	 * Popup post vine
	 */
	if($(window).width() > 980) {
		$('#content').magnificPopup({
			type: 'ajax',
			delegate: '.open-video-popup',
		 	gallery: {
				enabled: true
			},
			settings: {
	  			cache: false, 
	  			async: false
	  		},
			preloader: true,
			midClick: true,
			tError: 'The content could not be loaded.',
			callbacks: {
				ajaxContentAdded: function() {
		    		var id = $(this.content).find('video').attr('id');
		    		var width = $('#post_cont').width();
		    		var videoPlaying = false;
		    		$(this.content).find('video').css({
						position: 'relative',
					 	height: width
					});
					var v_binder = new video_binder(id, true);
					
					var height = $('#post_cont').height();
					$('#metas_cont .metas[id!="share"]').css('height', height - $('#metas_cont .nav-tabs').outerHeight() - $('#metas_cont .user_infos').outerHeight() - 90);
					twttr.widgets.load();
					var m_binder = new metas_binder();
			  	},
			  	change: function() {
			    	if(player) {
			    		player.pause();
			    		player.currentTime(0);
			    		player.dispose();
			    		player = null;
			    	}
			  	},
			    close: function() {
			    	if(player) {
			    		player.pause();
			    		player.currentTime(0);
			    		player.dispose();
			    		player = null;
			    	}
			    }
		  	},
		});
	}

	/**
	 * Infinite scroll
	 */
	if(autoload == '1') {
		var scrolling_ready = true;
		var deviceAgent = navigator.userAgent.toLowerCase();
		var agentID = deviceAgent.match(/(iphone|ipod|ipad|android)/);
		$(window).scroll(function() {
			if(scrolling_ready == false || $('.feeds_list .end_of_list').length > 0) return;
		    if
	    	(
	    		$(window).scrollTop() + $(window).height() == $(document).height() || agentID && ($(window).scrollTop() + $(window).height()) + 150 > $(document).height()
	    	) 
	    	{
		    	scrolling_ready = false;
		    	$.ajax({
					url: window.location.pathname+'/load/'+next_page,
					beforeSend:function() {
						$('.feeds_list').append('<li class="loader"></li>');
					},
					complete:function() {
						$('.feeds_list li.loader').remove();
						scrolling_ready = true;
					},
					success:function(datas) {
						if(datas) {
							var source = $('<section>'+datas+'</section>');
							source.find('li').hide();
							$('.feeds_list').append(source.html());
							$('.feeds_list').find('li:hidden').fadeIn('slow');
							twttr.widgets.load();
							next_page += 1;
						} else {
							$('.feeds_list').append('<li class="well end_of_list"><h2><a href="javascript:void(0);" onclick="$(\'body\').scrollTop(0);"><i class="icon-circle-arrow-up"></i>End of list. Back to top</a></h2></li>');
						}
					},
					error:function(){
					}
				});
	    	}
		});
	}

	//More search results
	$('.search_more_content').on('click', function(){
		var link = $(this);
		var page = parseInt(link.attr('rel'));
    	$.ajax({
			url: link.attr('href')+'/'+page,
			beforeSend:function() {
				link.parent().find('.loader').css('height', link.parent().height()+'px');
			},
			success:function(datas){
				if(link.attr('data-type') == 'tags') {
					link.before(datas);
					var count = parseInt($('#search_results_tags').attr('rel'));
					var current_count = $('.search_results_tags a.tag').length;
					if(current_count == count) link.remove();
				} else {
					$('.feeds_list.search .clear').before(datas);
					var count = parseInt($('.feeds_list.search').attr('rel'));
					var current_count = $('.feeds_list.search li').length;
					if(current_count == count) link.remove();
				}
				link.attr('rel', (page+1).toString());
				$('.loader').css('height', '0px');
			},
			error:function(){
				$('.loader').css('height', '0px');
			}
		});
		return false;
	});

	/**
	 * Page Post 
	 */
	 if($('.post_uniq').length) {
	 	autoload = '0';
	 	var v_binder = new video_binder($('video').attr('id'), false);
	 	var m_binder = new metas_binder();
	 }

});