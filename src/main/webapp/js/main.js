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

function getMoreNav(navigationName) {
    $.post("moreRefinements.html", {
        "navigationName" : navigationName,
        "originalQuery" : $('#originalQuery').text()
    }).done(function(data){
        if (data != "" || data != undefined) {
            var replace = document.getElementById("nav-"+navigationName);
            var remove = document.getElementById("more-"+navigationName);
            var html = document.createElement("div");
            html.innerHTML = data;
            replace.parentNode.replaceChild(html, replace);
            remove.parentNode.removeChild(remove);
        }else{
            console.log("No data received.");
        }
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