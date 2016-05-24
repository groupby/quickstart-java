<%@include file="tags.jsp"%>

<c:if test="${nav['or']}">
	<div id="nav-${nav.name}" class="navLink">
		<b>${nav.displayName}</b> <span class="attribute">OR (${nav.name})</span>
		<div class="nav-${nav.name}">
			<c:forEach items="${nav.refinements}" var="value">
				<div>
					<c:if test="${!gc:isRefinementSelected(results, nav.name, value.value)}">

						<div>
							<a style="color:white" href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, nav.name, value)}"/>">&#x2610; ${value.value}</a>
							<span class="count">(<fmt:formatNumber>${value['count'] }</fmt:formatNumber>)</span>
						</div>
					</c:if>
					<c:if test="${gc:isRefinementSelected(results, nav.name, value.value)}">
						<div>
							<a class="selected"  style="color:white" href="<c:url value="${b:toUrlRemove('default', results.query, results.selectedNavigation, nav.name, value)}"/>">&#x2611; ${value.value}</a>
							<span class="count">(<fmt:formatNumber>${value['count'] }</fmt:formatNumber>)</span>
						</div>
					</c:if>
				</div>
			</c:forEach>
		</div>
	</div>
</c:if>
<c:if test="${!nav['or']}">
	<div id="nav-${nav.name}" class="navLink">
		<b>${nav.displayName}</b> <span class="attribute">(${nav.name})</span>
		<div class="nav-${nav.name}">
			<c:forEach items="${nav.refinements}" var="value">
				<div>
					<a style="color:white" href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, nav.name, value)}"/>">${value.value} </a>
                    <span class="count">(<fmt:formatNumber>${value['count'] }</fmt:formatNumber>)</span>
				</div>
			</c:forEach>
		</div>
	</div>
</c:if>
<c:if test="${nav.isMoreRefinements()}">
	<div id="more-${nav.name}">
		<a style="color:white" href="javascript:;" onclick='getMoreNav("${nav.name}")'>More [+]</a>
	</div>
</c:if>