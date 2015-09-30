<%@include file="tags.jsp"%>

<c:if test="${nav['or']}">
	<div id="nav-${nav.name}" class="navLink">
		<b>${nav.displayName} (OR) </b>
		<div class="nav-${nav.name}">
			<c:forEach items="${nav.refinements}" var="value">
				<div>
					<c:if test="${!gc:isRefinementSelected(results, nav.name, value.value)}">

						<div>
							<a style="color:white" href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, nav.name, value)}"/>">&#x2610; ${value.value} (${value['count'] })</a>
						</div>
					</c:if>
					<c:if test="${gc:isRefinementSelected(results, nav.name, value.value)}">
						<div>
							<a class="selected"  style="color:white" href="<c:url value="${b:toUrlRemove('default', results.query, results.selectedNavigation, nav.name, value)}"/>">&#x2611; ${value.value} (${value['count'] })</a>
						</div>
					</c:if>
				</div>
			</c:forEach>
		</div>
	</div>
</c:if>
<c:if test="${!nav['or']}">
	<div id="nav-${nav.name}" class="navLink">
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
		$.post("${pageContext.request.contextPath}/moreRefinements.html", {
			"navigationName" : navigationName,
			"selectedRefinements": getSelectedRefinements()
		}).done(function(data){
			if (data != "" || data != undefined) {
				$('#nav-'+navigationName).replaceWith(data);
				$("#more-" + navigationName).fadeOut();
			}else{
				console.log("No data received.");
			}
		});
	}
</script>