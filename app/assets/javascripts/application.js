// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery.magnific-popup.min
//= require object
//= require_tree .
//= require jquery-ui-1.10.3.custom.min

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

    var window_height = $(window).height() - $('.navbar').outerHeight() - $('footer').outerHeight();
    $('#homepage_background').height(window_height + 'px');

    $('#list_avatars_container').css('width', $('#list_avatars_container li').length * 90 + 'px');

    $('body').click(function() {
        $('.display_settings').removeClass('active');
        var style = {
            display: 'none'
        };
        $('#settings_dropdown').css(style);
    });

    $('.display_settings').parent().click(function() {
        if ($('#settings_dropdown').is(':hidden')) {
            $('.display_settings').addClass('active');
            var style = {
                display: 'block'
            };
        } else {
            $('.display_settings').removeClass('active');
            var style = {
                display: 'none'
            };
        }
        $('#settings_dropdown').css(style);
        return false;
    });

    $('#settings_dropdown .set_size').click(function() {
        $.ajax({
            url: $(this).attr('href'),
            beforeSend: function() {
                mask.show();
            },
            complete: function() {
                mask.hide();
            },
            success: function() {
                window.location.reload();
            },
            error: function() {
            }
        });
        return false;
    });

    $('#settings_dropdown .set_autoload').click(function() {
        if ($(this).is(':checked')) {
            var set_autoload = '1';
        } else {
            var set_autoload = '0';
        }
        $.ajax({
            url: '/autoload/' + set_autoload,
            beforeSend: function() {
                mask.show();
            },
            complete: function() {
                mask.hide();
            },
            success: function() {
                window.location.reload();
            },
            error: function() {
            }
        });
    });

    $('#settings_dropdown .set_autoplay').click(function() {
        if ($(this).is(':checked')) {
            var set_autoplay = '1';
        } else {
            var set_autoplay = '0';
        }
        $.ajax({
            url: '/autoplay/' + set_autoplay,
            beforeSend: function() {
                mask.show();
            },
            complete: function() {
                mask.hide();
            },
            success: function() {
                if (set_autoplay == '1') {
                    autoplay = true;
                } else {
                    autoplay = false;
                }
            },
            error: function() {
            }
        });
    });

    $('#settings_dropdown #slider').slider({
        min: 0,
        max: 10,
        step: 1,
        value: volume * 10,
        change: function(event, ui) {
            $('#settings_dropdown #amount').html(ui.value);
            volume = ui.value / 10;
            if (ui.value > 0) {
                ex_volume = volume;
            }
        },
        stop: function(event, ui) {
            $.ajax({
                url: '/volume/' + ui.value,
                beforeSend: function() {
                    mask.show();
                },
                complete: function() {
                    mask.hide();
                },
            });
        }
    });

    $('#list_avatars_container').on({
        mouseenter: function() {
            $(this).prepend('<div class="avatar_mask">' + $(this).find('img').attr('alt') + '</div>');
        },
        mouseleave: function() {
            $('.avatar_mask').remove();
        }
    }, 'a');

    $('.feeds_list').on('click', '.open-video-popup-alt', function() {
        $('.open-video-popup[href="' + $(this).attr('href') + '"]').trigger('click');
        return false;
    });

    $('#content').magnificPopup({
        delegate: '.open-video-popup',
        gallery: {
            enabled: true
        },
        preloader: false,
        type: 'inline',
        midClick: true,
        callbacks: {
            open: function() {
                var id = $(this.currItem.inlineElement).find('video').attr('id');
                videojs(id, {
                    'controls': false
                }).ready(function() {
                    player = this;
                    player.volume(volume);
                    if (volume > 0) {
                        $('.mute-button').removeClass('off').addClass('on');
                    } else {
                        $('.mute-button').removeClass('on').addClass('off');
                    }
                    if (autoplay == '1') {
                        player.play();
                    }
                });
            },
            close: function() {
                if (player) {
                    player.pause();
                    player.currentTime(0);
                    player = null;
                }
            },
            afterChange: function() {
                var id = $(this.currItem.inlineElement).find('video').attr('id');
                var src = $(this.currItem.inlineElement).find('source').attr('src');
                if (player) {
                    player.currentTime(0);
                    player = null;
                    videojs(id, {
                        'controls': false
                    }).ready(function() {
                        player = this;
                        player.volume(volume);
                        if (volume > 0) {
                            $('.mute-button').removeClass('off').addClass('on');
                        } else {
                            $('.mute-button').removeClass('on').addClass('off');
                        }
                        if (autoplay == '1') {
                            player.play();
                        }
                    });
                }
            }
        },
    });

    $('.feeds_list').on('click', 'video', function() {
        if (player.paused()) {
            player.play()
        } else {
            player.pause()
        }
    });

    $('.feeds_list').on('click', '.mute-button', function() {
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
        $('#settings_dropdown #slider').slider('value', volume * 10);
        player.volume(volume);
        return false;
    });

    $('.feeds_list').magnificPopup({
        delegate: '.open-metas-popup',
        type: 'ajax',
        settings: {
            cache: false,
            async: false
        },
        cursor: 'mfp-ajax-cur',
        tError: '<a href="%url%">The content</a> could not be loaded.',
        callbacks: {
            ajaxContentAdded: function() {
                $('.metas_list').on('click', '.btn-primary', function() {
                    var link = $(this);
                    $.ajax({
                        url: link.attr('href'),
                        beforeSend: function() {
                            $('.loader').show();
                        },
                        success: function(data) {
                            $('.metas_list li').fadeIn('fast', function() {
                                $('.metas_list').html('').append(data);
                            });
                            $('.loader').hide();
                        },
                        error: function() {
                            $('.loader').hide();
                        }
                    });
                    return false;
                });
            }
        }
    });

    if (autoload == '1') {
        var scrolling_ready = true;
        var deviceAgent = navigator.userAgent.toLowerCase();
        var agentID = deviceAgent.match(/(iphone|ipod|ipad|android)/);
        $(window).scroll(function() {
            if (scrolling_ready == false || $('.feeds_list .end_of_list').length > 0)
                return;
            if (
                    $(window).scrollTop() + $(window).height()
                    ==
                    $(document).height()
                    ||
                    agentID && ($(window).scrollTop() + $(window).height()) + 150 > $(document).height()
                    ) {
                scrolling_ready = false;
                $.ajax({
                    url: window.location.pathname + '/load/' + next_page,
                    beforeSend: function() {
                        $('.feeds_list').append('<li class="loader"></li>');
                    },
                    complete: function() {
                        $('.feeds_list li.loader').remove();
                        scrolling_ready = true;
                    },
                    success: function(datas) {
                        if (datas) {
                            var source = $('<section>' + datas + '</section>');
                            source.find('li').hide();
                            $('.feeds_list').append(source.html());
                            $('.feeds_list').find('li:hidden').fadeIn('slow');
                            next_page += 1;
                        } else {
                            $('.feeds_list').append('<li class="well end_of_list"><h2><a href="javascript:void(0);" onclick="$(\'body\').scrollTop(0);"><i class="icon-circle-arrow-up"></i>End of list. Back to top</a></h2></li>');
                        }
                    },
                    error: function() {
                    }
                });
            }
        });
    }

});