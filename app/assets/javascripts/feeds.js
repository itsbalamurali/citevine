$(document).ready(function() {

    //More search results
    $('.search_more_content').on('click', function() {
        var link = $(this);
        var page = parseInt(link.attr('rel'));
        $.ajax({
            url: link.attr('href') + '/' + page,
            beforeSend: function() {
                link.parent().find('.loader').css('height', link.parent().height() + 'px');
            },
            success: function(datas) {
                if (link.attr('data-type') == 'tags') {
                    link.before(datas);
                } else {
                    $('.feeds_list.search .clear').before(datas);
                    var count = parseInt($('.feeds_list.search').attr('rel'));
                    var current_count = $('.feeds_list.search li').length;
                    if (current_count == count) {
                        link.remove();
                    }
                }
                link.attr('rel', (page + 1).toString());
                $('.loader').css('height', '0px');
            },
            error: function() {
                $('.loader').css('height', '0px');
            }
        });
        return false;
    });
});