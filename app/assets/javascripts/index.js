$(document).ready(function() {

	var Bubble = Class.extend({
		init: function() {
			this.timer = null;
			this.bubble = null;
			this.tag = 0;
			this.elementSize = 136;
			/*if($(window).width() < 700 || $(window).height() < 800) {
				this.maxItems = 1;
			} else {
				this.maxItems = 10;
			}*/
			/*this.homepage = {
				minLeft: 0 + this.elementSize,
				minTop: 0 + this.elementSize,
				maxLeft: $('#homepage').width() - this.elementSize,
				maxTop: $('#homepage').height() - this.elementSize
			};*/
			this.process();
			this.getBubble();
		},
		process: function() {
			if($(window).width() < 700 || $(window).height() < 800) {
				this.maxItems = 1;
			} else {
				this.maxItems = 10;
			}
			var window_height = $(window).height()-$('.navbar').outerHeight()-$('footer').outerHeight();
			$('#homepage_background').height(window_height+'px');
			this.homepage = {
				minLeft: 0 + this.elementSize,
				minTop: 0 + this.elementSize,
				maxLeft: $('#homepage').width() - this.elementSize,
				maxTop: $('#homepage').height() - this.elementSize
			};
			this.positions = [];
			this.currentPosition = -1;
			$('.bubble').each(function(index, element) {
				$(element).fadeOut(400, function(){
					$(this).remove();
				});
			});
		},
		createTimer: function() {
			var __that = this;
			this.timer = setTimeout(function() {
				__that.getBubble();
			}, 500);
		},
		getBubble: function() {
			var __that = this;
			$.ajax({
				url: '/item/'+__that.tag,
				beforeSend:function() {
				},
				complete: function() {
					clearTimeout(__that.timer);
					__that.createTimer();	
				},
				success:function(data) {
					if(__that.tag <= 10) {
						__that.tag += 1;
					} else {
						__that.tag = 0;
					}
					__that.bubble = data;
					__that.calcPosition();
					__that.appendBubble();
				},
				error:function() {
				}
			});
		},
		calcPosition: function() {
			function getRandom(min, max) {
		  		return Math.random() * (max - min) + min;
			}

			var __that = this;
			var Colision = Class.extend({
				init: function() {
					this.top = __that.elementSize;
					this.left = __that.elementSize;
					this.calcPos();
				},
				calcPos: function() {
					this.top = Math.floor(getRandom(__that.elementSize, __that.homepage.maxTop));
					this.left = Math.floor(getRandom(__that.elementSize, __that.homepage.maxLeft));
					$.each(__that.positions, function(index, bubble) {
						var diff_top = this.top - bubble.top;
						diff_top = Math.abs(diff_top);
						var diff_left = this.left - bubble.left;
						diff_left = Math.abs(diff_left);
						if(diff_top < __that.elementSize && diff_left < __that.elementSize) {
							this.calcPos();
							return false;
						}
					}.bind(this));
				}
			});
			var colision = new Colision();

			if(this.positions.length == this.maxItems) {
				this.currentPosition = this.positions[0].index;
				$('.bubble#element_'+this.currentPosition).fadeOut(400, function(){
					$(this).remove();
				});
				this.positions.shift();
				this.positions.length = this.maxItems-1;
			} else {
				this.currentPosition++;
			}

			var bubble = {
				index: this.currentPosition,
				top: colision.top,
				left: colision.left
			};
			this.positions.push(bubble);
		},
		appendBubble: function() {
			$bubble_div = $('<div/>').hide();
			$bubble_div.attr({
				'id': 'element_'+this.positions[this.positions.length-1].index,
				'class': 'bubble'
			});
			$bubble_div.css({
				'top' : this.positions[this.positions.length-1].top,
				'left' : this.positions[this.positions.length-1].left
			});
			$bubble_div.html(this.bubble);
			$('#homepage').append($bubble_div);
			var marker_random_rotation = Math.floor(Math.random() * (179 - 0));
			$bubble_div.find('.marker').css({
				'-moz-transform':'rotate('+marker_random_rotation+'deg)',
	          	'-webkit-transform':'rotate('+marker_random_rotation+'deg)',
		        '-o-transform':'rotate('+marker_random_rotation+'deg)',
				'-ms-transform':'rotate('+marker_random_rotation+'deg)',
				'transform': 'rotate('+marker_random_rotation+'deg)'
			});
			$bubble_div.fadeIn(400);
		}
	});

	if($('#homepage_background').length > 0) {

		$(window).resize(function() {
			bubble.process();
		});
		var bubble = new Bubble();
	}

});