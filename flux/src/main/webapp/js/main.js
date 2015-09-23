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
    var unrefined = selected.sanitize(selected);
    var refined = [];
    for(var i=0; i<unrefined.length; i++){
        refined.push(unrefined[i].split("=")[1]);
    }
    return refined.toString();
}

Array.prototype.sanitize = function() {
    for (var i = 0; i < this.length; i++) {
        if (this[i] == "") {
            this.splice(i, 1);
            i--;
        }
    }
    return this;
};