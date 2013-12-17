//= require jquery
//= require jquery_ujs
//= require_directory ./lib/

/**
 * Loading mask
 */
var Mask = Class.extend({
	show: function() {
		$('body').prepend('<div id="body_mask"></div>');
	},
	hide: function() {
		$('#body_mask').remove();
	}
});
var mask = new Mask();

$(document).ready(function() {

	var player;
	var ex_volume = volume;

	/**
	 * Dropdown Settings
	 */
	$('.display_settings').parent().click(function() {
		if($('#settings_dropdown').is(':hidden')) {
			$('.display_settings').addClass('active');
		  	$('#settings_dropdown').css('display', 'block');
		} else {
			$('.display_settings').removeClass('active');
		  	$('#settings_dropdown').css('display', 'none');
		}
	});

	/**
	 * Hide dropdown Settings
	 */
	$('body').click(function(e){
		if($(e.target).hasClass('display_settings')) return false;
		$('.display_settings').removeClass('active');
	  	$('#settings_dropdown').css('display', 'none');
	});

	/**
	 * Settings size
	 */
	$('#settings_dropdown .set_size').click(function() {
		$.ajax({
			url: $(this).attr('href'),
			beforeSend:function(){
				mask.show();
			},
			complete:function(){
				mask.hide();
			},
			success:function(){
				window.location.reload();
			},
			error:function(){
			}
		});
		return false;
	});

	/**
	 * Settings infinite loading checkbox
	 */
	$('#settings_dropdown .set_autoload').click(function() {
		if($(this).is(':checked')) {
			var set_autoload = '1';
		} else {
			var set_autoload = '0';
		}
		$.ajax({
			url: '/autoload/'+set_autoload,
			beforeSend:function(){
				mask.show();
			},
			complete:function(){
				mask.hide();
			},
			success:function(){
				window.location.reload();
			},
			error:function(){
			}
		});
		return false;
	});

	/**
	 * Settings autoplay checkbox
	 */
	$('#settings_dropdown .set_autoplay').click(function() {
		if($(this).is(':checked')) {
			var set_autoplay = '1';
		} else {
			var set_autoplay = '0';
		}
		$.ajax({
			url: '/autoplay/'+set_autoplay,
			beforeSend:function(){
				mask.show();
			},
			complete:function(){
				mask.hide();
			},
			success:function(){
				if(set_autoplay == '1') {
					autoplay = true;
				} else {
					autoplay = false;
				}
			},
			error:function(){
			}
		});
		return false;
	});

	/**
	 * Settings Slider volume
	 */
	$('#settings_dropdown #slider').slider({
	  	min: 0,
	  	max: 10,
	  	step: 1,
	  	value: volume*10,
	  	change: function(event, ui) {
	  		$('#settings_dropdown #amount').html(ui.value);
	  		volume = ui.value/10;
	  		if(ui.value > 0) {
	  			ex_volume = volume;
	  		}
	  	},
	  	stop: function(event, ui) {
	    	$.ajax({
				url: '/volume/'+ui.value,
				beforeSend:function(){
					mask.show();
				},
				complete:function(){
					mask.hide();
				},
			});
	  	}
    });

});