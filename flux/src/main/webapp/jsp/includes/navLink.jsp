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
		<div class="nav-${nav.name}">
			<c:forEach items="${nav.refinements}" var="value">
				<div>
					<a style="color:white" href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, nav.name, value)}"/>">${value.value} (${value['count'] })</a>
				</div>
			</c:forEach>
		</div>
	</div>
</c:if>
<c:if test="${nav.isMoreRefinements()}">
	<div id="more-${nav.name}">
		<a style="color:white" href="#" onclick='getMoreNav("${nav.name}")'>More [+]</a>
	</div>
</c:if>

<script>
	function getMoreNav(navigationName) {

		$.post("${pageContext.request.contextPath}/json.html", {
			"navigationName" : navigationName
		}).done(function (data) {
			if (data != "" || data != undefined) {
				$(".nav-" + navigationName).replaceWith(data);
				$("#more-" + navigationName).fadeOut();
			} else {
				location.reload();
			}
		});
	}
</script>