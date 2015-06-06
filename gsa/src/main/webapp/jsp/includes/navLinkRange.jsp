<%@include file="tags.jsp"%>

<div class="navLink">
<b>${nav.displayName}</b>
<c:forEach items="${nav.refinements}" var="value">
<div>
  <a style="color:white" href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, 'selected', value)}"/>">
		  <fmt:formatNumber pattern="0.00">${value['low']}</fmt:formatNumber> 
	      ${empty value['high'] ? '+' : '-'} 
	      <fmt:formatNumber pattern="0.00">${value['high']}</fmt:formatNumber>
	      (${value['count'] })
  </a>
</div>
</c:forEach>
</div>