<c:if test="${!empty error or !empty results.errors}">
    <div id="error">
<pre style="white-space:normal;font-family:courier;font-size:12px;color:grey;padding:4px;">
Error: ${error}
${results.errors}
</pre>
    </div>
</c:if>
<c:if test="${!empty cause}">
    <div id="cause">
<pre style="white-space:normal;font-family:courier;font-size:12px;color:grey;padding:4px;">
Cause: ${cause}
</pre>
    </div>
</c:if>
<div id="raw">
    Raw Query completed in <span
        title="${time > 600 ? 'Response time is very long and might impact user experience' : time > 400 ? 'Response time is not optimal' : 'Response time nominal'}"
        class="number ${time > 600 ? 'largeResponse' : time > 400 ? 'mediumResponse' : 'smallResponse'}">
        ${time}</span>ms:
  <pre style="white-space:normal;font-family:courier;font-size:12px;color:grey;padding:4px;">
curl -d '${rawQuery}' "https://${customerId}.groupbycloud.com/api/v1/search?pretty"
  </pre>
    Raw JSON Response (<span
        title="${fn:length(resultsJson) > 50000 ? 'This response is large and could cause network transfer latency.  Try removing the number of fields returned, or reducing the page size' : fn:length(resultsJson) > 25000 ? 'Response size is getting large, might be worth keeping an eye on response times.' : 'Response size nominal.'}"
        class="number ${fn:length(resultsJson) > 50000 ? 'largeResponse' : fn:length(resultsJson) > 25000 ? 'mediumResponse' : 'smallResponse'}">
        ${fn:length(resultsJson)}</span> bytes)
    <a href="javascript:;" onclick="$.cookie('expanded', !$('#rawJsonResponse').is(':visible'));$('#rawJsonResponse').toggle('slide')">show >></a>
    <div id="rawJsonResponse" style="display: none">
        ${resultsJson}
    </div>
    <script>
        function sortObject(o) {
            var sorted = {}, key, a = [];

            for (key in o) {
                if (o.hasOwnProperty(key)) {
                    a.push(key);
                }
            }
            a.sort();
            for (key = 0; key < a.length; key++) {
                sorted[a[key]] = o[a[key]];
            }
            return sorted;
        }
        var obj = JSON.parse($('#rawJsonResponse').html());
        obj = sortObject(obj);
        $('#rawJsonResponse').JSONView(obj, { collapsed: false });
        $('.number').each(function(){
            $(this).html(numeral($(this).html()).format('0,0'));
        });

        var expandedList = $.cookie('maintainExpanded');
        console.log('page: ' + expandedList);
        console.log('clientKey: ' + $.cookie('clientKey'));
        console.log('customerId: ' + $.cookie('customerId'));
        console.log('fields: ' + $.cookie('fields'));
        console.log('expanded: ' + $.cookie('expanded'));
        console.log('maintainExpanded: ' + $.cookie('maintainExpanded'));
        if (!expandedList){
            expandedList = '';
        }
        $('ul li div.collapser').each(function(){
            if ($(this).parent().parent().hasClass('level0')){
                $(this).addClass('maintainExpanded');
                var name = $(this).siblings().first().text();
                var trimmedName = name.substring(1,name.length -1);
                if (expandedList.indexOf(',' + trimmedName + ',') == -1) {
                    $(this).click();
                }
            }
        });

        $('.maintainExpanded').click(function(){
            expandedList = ',';
            $('.maintainExpanded').each(function(){
                if ($(this).html() === '-') {
                    var name = $(this).siblings().first().text();
                    var trimmedName = name.substring(1,name.length -1);
                    expandedList += trimmedName + ','
                }
            });
            $.cookie('maintainExpanded', expandedList);
            console.log('save: ' + expandedList);
        });

        if ($.cookie('expanded') === 'true'){
            $('#rawJsonResponse').show();
        }
    </script>
</div>