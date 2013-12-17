$(document).ready(function() {
	
	var window_height = $(window).height()-$('.navbar').outerHeight()-$('footer').outerHeight();
	window_height+=100;
	$('#homepage_background').css({
		'min-height': window_height+'px'
	});

	$(window).scroll(function(){
		if($(document).scrollTop() > 300) {
			$('.navbar-fixed-top').css('z-index', '0');
		} else {
			$('.navbar-fixed-top').css('z-index', '9999');
		}
	});

	/**
	 * Owl slider
	 */
	var owl = $("#owl-demo");
	owl.owlCarousel({
		items : 5, //10 items above 1000px browser width
		itemsDesktop : [1000,5], //5 items between 1000px and 901px
		itemsDesktopSmall : [900,3], // betweem 900px and 601px
		itemsTablet: [600,2], //2 items between 600 and 0
		itemsMobile : false, // itemsMobile disabled - inherit from itemsTablet 
		pagination: false
	});

	// Custom Navigation Events
  	$(".next").click(function(){
 		owl.trigger('owl.next');
  	});

  	$(".prev").click(function(){
	    owl.trigger('owl.prev');
	});

	/**
	 * Video play homepage
	 */
 	var videoPlaying = false;
 	var ex_volume = volume;
 	var player;

 	$('img.popular_video').click(function(){
	 	//reset existing players
	 	if(player) {
    		player.pause();
    		$('video').hide();
    		$('div.video-js').hide();
    	}
	 	var $__that = $(this);
 		var id = $(this).parent().find('video').attr('id');
		videojs(id, {
			'controls': false,
			'width': $__that.width(),
			'height': $__that.height()
		}).ready(function(){
			player = this;
	  		player.volume(volume);
	  		player.play();
	  		videoPlaying = true;
	  		$__that.parent().find('div.video-js').show();
	  		$__that.parent().find('video').show();
	  		if(volume > 0) {
	  			$('.mute-button').removeClass('off').addClass('on');
	  		} else {
	  			$('.mute-button').removeClass('on').addClass('off');
	  		}
		});
		$(this).parent().find('video').off('click');
		$(this).parent().find('video').on('click', function(){
  			if(videoPlaying) {
  				player.pause();
  				videoPlaying = false;
  			} else {
				player.play();
				videoPlaying = true;
  			}
  			return false;
		});
 	});

	$('.mute-button').click(function() {
		//put on
		if (player.volume() == 0) {
			$('.mute-button').removeClass('off');
			$('.mute-button').addClass('on');
			volume = ex_volume;
		//put off
		} else {
			$('.mute-button').removeClass('on');
			$('.mute-button').addClass('off');
			volume = 0;
		}
		$('#settings_dropdown #slider').slider('value', volume*10);
		player.volume(volume);
		return false;
	});

});