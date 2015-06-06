<%@include file="tags.jsp"%>

<c:if test="${nav['or']}">
	<div class="navLink">
	<b>${nav.displayName} (OR) </b>
	<c:forEach items="${nav.refinements}" var="value">
	<div>
		<input style="vertical-align: middle" type="checkbox" onchange="$('#refinements').val($('#refinements').val() + '~' + $(this).val());" id="${value.id }" value="<c:out value="${nav['name']}=${value['value']}"/>">${value.value} (${value['count'] })
	</div>
	</c:forEach>
	</div>
	<a href="javascript:$('#form').submit();" style="float:right;margin-right:5px;">Apply >></a>
	<br>
</c:if>
<c:if test="${!nav['or']}">
	<div class="navLink">
	<b>${nav.displayName} </b>
	<c:forEach items="${nav.refinements}" var="value">
	<div>
		<a style="color:white" href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, nav.name, value)}"/>">${value.value} (${value['count'] })</a>
	</div>
	</c:forEach>
	</div>
</c:if>
