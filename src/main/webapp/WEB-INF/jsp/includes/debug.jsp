<c:set var="name" value="resultsJson${index}"/>
<c:set var="resultsJson" value="${model[name]}"/>

<c:set var="name" value="rawQuery${index}"/>
<c:set var="rawQuery" value="${model[name]}"/>

<c:set var="name" value="cause${index}"/>
<c:set var="cause" value="${model[name]}"/>

<c:set var="name" value="time${index}"/>
<c:set var="time" value="${model[name]}"/>

<fieldset>
<legend><span>Query Inspection</span></legend>
<div id="debug${index}">


<c:if test="${!empty cause}">
    <div id="cause">
        <pre>
        Cause: ${cause}
        </pre>
    </div>
</c:if>
<div id="raw">
    <ul class="inspection">
        <li>
            Query completed in <span
            title="${time > 600 ? 'Response time is very long and might impact user experience' : time > 400 ? 'Response time is not optimal' : 'Response time nominal'}"
            class="number ${time > 600 ? 'largeResponse' : time > 400 ? 'mediumResponse' : 'smallResponse'}">
            ${time}</span> ms <a href="javascript:;" onclick="showRawQuery()" class="btn scnd sml">View curl script</a>
            <c:set var="bridgeHeaderName" value="bridgeHeaders${index}"/><br>
            <c:set var="bridgeHeaders"><c:forEach var="bridgeHeader" items="${model[bridgeHeaderName]}"> -H "${bridgeHeader}"</c:forEach></c:set>
            <div class="raw-query-area" style="display:${cookie.showRawQuery.value ? 'block' : 'none'}">
              <pre id="expandedQuery${index}" class="rawQuery">curl ${bridgeHeaders} -d '${rawQuery}' "https://${customerId}.groupbycloud.com/api/v1/search?pretty"</pre>
              <button class="copy btn scnd sml" data-clipboard-target="#expandedQuery${index}">Copy to Clipboard</button>
            </div>
        </li>
        <li>
            JSON Response Size (<span
            title="${fn:length(resultsJson) > 50000 ? 'This response is large and could cause network transfer latency.  Try removing the number of fields returned, or reducing the page size' : fn:length(resultsJson) > 25000 ? 'Response size is getting large, might be worth keeping an eye on response times.' : 'Response size nominal.'}"
            class="number ${fn:length(resultsJson) > 50000 ? 'largeResponse' : fn:length(resultsJson) > 25000 ? 'mediumResponse' : 'smallResponse'}">
            <fmt:formatNumber>${fn:length(resultsJson)}</fmt:formatNumber></span> bytes) <a href="javascript:;" onclick="showJsonResponse()" class="btn scnd sml">view raw json</a>
            <div class="json-response-area" style="display: ${cookie.showJsonResponse.value ? 'block' : 'none'}">
              <div id="rawJsonResponse${index}" class="jsonResponse">
                <c:out value="${resultsJson}"/>
              </div>
              <span id="copyable-json${index}" class="hide-me"><c:out value="${resultsJson}"/></span>
              <button class="copy btn scnd sml" data-clipboard-target="#copyable-json${index}">Copy to Clipboard</button>
            </div>
        </li>
        <li>Record count: <span>${results.totalRecordCount}</span></li>
        <li>Original Query: <span>${results.originalQuery}</span></li>
        <li>Corrected Query: <span>${results.correctedQuery}</span></li>
        <li>Did You Means: <span>${results.didYouMean}</span></li>
        <li>Rewrites: <span>${results.rewrites}</span></li>
    </ul>

    <%@include file="../includes/siteParams.jsp"%>
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
</>

</div>
</fieldset>
