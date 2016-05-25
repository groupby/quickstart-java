<%@include file="tags.jsp"%>

<div class="navLink">
<b>${nav.displayName} <span class="attribute">${nav.name}</span></b>
<c:forEach items="${nav.refinements}" var="value">
<div>
  <a style="color:white" href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, nav.name, value)}"/>">
		  <fmt:formatNumber pattern="0.00">${value['low']}</fmt:formatNumber> 
	      ${empty value['high'] ? '+' : '-'} 
	      <fmt:formatNumber pattern="0.00">${value['high']}</fmt:formatNumber>
  </a>
  <span class="count">(<fmt:formatNumber>${value['count'] }</fmt:formatNumber>)</span>
</div>
</c:forEach>
</div>