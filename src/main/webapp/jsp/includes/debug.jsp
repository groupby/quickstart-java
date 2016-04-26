<div id="debug${index}">
<c:set var="name" value="error${index}"/>
<c:set var="error" value="${model[name]}"/>

<c:set var="name" value="resultsJson${index}"/>
<c:set var="resultsJson" value="${model[name]}"/>

<c:set var="name" value="rawQuery${index}"/>
<c:set var="rawQuery" value="${model[name]}"/>

<c:set var="name" value="cause${index}"/>
<c:set var="cause" value="${model[name]}"/>

<c:set var="name" value="time${index}"/>
<c:set var="time" value="${model[name]}"/>

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
        ${time}</span> ms:
    <a href="javascript:;" onclick="$.cookie('expandedQuery${index}', !$('#expandedQuery${index}').is(':visible'));$('#expandedQuery${index}').toggle('slide')">show >></a>
  <pre id="expandedQuery${index}" style="white-space:normal;font-family:courier;font-size:12px;color:grey;padding:4px;display:none">
curl -d '${rawQuery}' "https://${customerId}.groupbycloud.com/api/v1/search?pretty"
  </pre>
    <br>
    Raw JSON Response (<span
        title="${fn:length(resultsJson) > 50000 ? 'This response is large and could cause network transfer latency.  Try removing the number of fields returned, or reducing the page size' : fn:length(resultsJson) > 25000 ? 'Response size is getting large, might be worth keeping an eye on response times.' : 'Response size nominal.'}"
        class="number ${fn:length(resultsJson) > 50000 ? 'largeResponse' : fn:length(resultsJson) > 25000 ? 'mediumResponse' : 'smallResponse'}">
        <fmt:formatNumber>${fn:length(resultsJson)}</fmt:formatNumber></span> bytes)
    <a href="javascript:;" onclick="$.cookie('expanded${index}', !$('#rawJsonResponse${index}').is(':visible'));$('#rawJsonResponse${index}').toggle('slide')">show >></a>
    <div id="rawJsonResponse${index}" style="display: none">
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
        var obj = JSON.parse($('#rawJsonResponse${index}').html());
        obj = sortObject(obj);
        $('#rawJsonResponse${index}').JSONView(obj, { collapsed: false });
        $('#debug${index} .number').each(function(){
            var that = $(this);
            that.html(numeral(that.html()).format('0,0'));
        });

        var expandedList${index} = $.cookie('maintainExpanded${index}');
        
        if (!expandedList${index}){
            expandedList${index} = '';
        }
        $('#rawJsonResponse${index} ul li div.collapser').each(function(){
            if ($(this).parent().parent().hasClass('level0')){
                $(this).addClass('maintainExpanded${index}');
                var name = $(this).siblings().first().text();
                var trimmedName = name.substring(1,name.length -1);
                if (expandedList${index}.indexOf(',' + trimmedName + ',') == -1) {
                    $(this).click();
                }
            }
        });

        $('.maintainExpanded${index}').click(function(){
            expandedList${index} = ',';
            $('.maintainExpanded${index}').each(function(){
                if ($(this).html() === '-') {
                    var name = $(this).siblings().first().text();
                    var trimmedName = name.substring(1,name.length -1);
                    expandedList${index} += trimmedName + ','
                }
            });
            $.cookie('maintainExpanded${index}', expandedList${index});
        });

        if ($.cookie('expanded${index}') === 'true'){
            $('#rawJsonResponse${index}').show();
        }

        if ($.cookie('expandedQuery${index}') === 'true'){
            $('#expandedQuery${index}').show();
        }
    </script>
</div>

</div>