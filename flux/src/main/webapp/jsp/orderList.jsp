<%@include file="includes/tags.jsp"%>
<c:set var="biasingProfileCount" value="${model.biasingProfileCount}"/>


<c:forEach begin="0" end="${biasingProfileCount -1}" varStatus="b">
    <c:set var="name" value="results${b.index}"/>
    <c:set var="results" value="${model[name]}"/>

    <ol class="replacementRow" data-count="${b.index}" id="replacementRow${b.index}">
        <%@include file="includes/record.jsp"%>
    </ol>

</c:forEach>
