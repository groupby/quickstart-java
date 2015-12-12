$(document).ready(function () {
    setInterval(redoQuery, 1000);
    prettyJson();
});

function redoQuery() {
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
        dataType: 'json'
    }).done(function (pResponse) {
        $('#scratchArea').html(pResponse);
        $('.replacementRow').each(function () {
            var row = $(this).attr('data-count');
            $('#row' + row).quicksand($('#replacementRow' + row + ' li'))
        });
    });
}


function prettyJson() {
    $('.reformatJson').each(function (index, element) {
        try {
            var e = $(element);
            e.html(e.html()
                    .replace(/\[\{/g, '[<br/>{')
                    .replace(/},/g, '},<br/>')
                    .replace(/}]/g, '}<br/>]')
            );
        } catch (exception) {
            console.log('parse exception: ', exception);
        }
    });
}

function getSelectedRefinements(){
    var selected = $('#refinements').val().split("~");
    return sanitize(selected).toString();
}

function sanitize(data){
    for (var i = 0; i < data.length; i++) {
        if (data[i] == "") {
            data.splice(i, 1);
            i--;
        }
    }
    return data;
}