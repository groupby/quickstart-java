$(document).ready(function () {
    setInterval(redoQuery, 1000);
    prettyJson();
    if (!$('#raw').prop('checked')) {
        $('.jsonValue').each(function(index, value){
          try {
            $(this).JSONView(JSON.parse($(this).text()), { collapsed: $('#collapse').prop('checked')});
            $(this).show();
          } catch (e) {
            console.log(e);
          }
        });
    }
});

function showAdvanced(){
    $('#advanced').toggle('slide', function(){
        $.cookie('showAdvanced', $('#advanced').is(":visible"));
    });
}
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

    var currentHash = location.hash;
    if (currentHash){
        var hashes = currentHash.substring(1).split('&');
        hashes.forEach(function(pItem){
            var keyValue = pItem.split('=');
            if (keyValue && keyValue.length == 2 && keyValue[0] && keyValue[1] && keyValue[1] !== 'undefined') {
                $('#' + keyValue[0]).attr('value', keyValue[1]);
                $.cookie(keyValue[0], keyValue[1]);
            }
        });
    }
    var customerIdFromRequestScopeExists = ${!empty customerId};
    if ($('#customerId').attr('value') && !customerIdFromRequestScopeExists){
        self.location.reload();
    }

    $('#cookieForm input').each(function(){
        $(this).keypress(function(e) {
            var code = (e.keyCode ? e.keyCode : e.which);
             if (code == 13) {
                e.preventDefault();
                e.stopPropagation();
                saveForm();
                $('#form').submit();
             }
         });
    });
    function saveForm() {
        $('#cookieForm input').each(function(){
            var myId = $(this).attr('id');
            var type = $(this).attr('type');
            if ($.cookie(myId)) {
                if (type === 'checkbox'){
                  $(this).prop("checked", $.cookie(myId) === 'true');
                } else {
                    $(this).val($.cookie(myId));
                }
            }
        });
        generateHash();
    }
    function generateHash() {
        var hashLocation = '';
        $('#cookieForm input').each(function(){
            var myId = $(this).attr('id');
            if ($.cookie(myId)) {
                hashLocation += myId + '=' + $.cookie($(this).attr('id')) + '&';
            }
        });
        location.hash = hashLocation;
    }
    saveForm();
    $('#cookieForm input').bind('keyup blur click change', function(){
        var type = $(this).attr('type');
        if (type === 'checkbox') {
            $.cookie($(this).attr('id'), $(this).prop('checked'));
        } else {
            $.cookie($(this).attr('id'), $(this).val());
        }
        generateHash();
    });

    $('#form').submit(function(e){
        saveForm();
    });