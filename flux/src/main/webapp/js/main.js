$(document).ready(function(){
   setInterval(redoQuery, 1000);
});

function redoQuery(){
    if ($.cookie('reload') == 'true') {
        $.cookie('reload', 'false');
    } else {
        return;
    }
    var sForm = $('#form').serialize();
    $.ajax({
        type: 'post',
        url: 'index.html',
        data: $('#form').serialize() + '&action=getOrderList',
        dataTYpe: 'json'
    }).done(function(pResponse){
        $('#scratchArea').html(pResponse);
        $('.replacementRow').each(function(){
            var row = $(this).attr('data-count');
            $('#row' + row).quicksand($('#replacementRow' + row + ' li'))
        });
    });
}