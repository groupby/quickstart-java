<%@include file="tags.jsp"%>
<a href="<c:url value="${b:toUrlRemove('default', results.query, results.selectedNavigation, navigation.name, refinement)}"/>">
  <span class="deleteCheckbox">x</span>
  <c:out value="${navigation.displayName}"/></b>: <fmt:formatNumber pattern="0.00">${refinement.low}</fmt:formatNumber> ${empty refinement.high ? '+' : ' - '}${empty refinement.high ? '+' : prefix}<fmt:formatNumber pattern="0.00">${refinement.high}</fmt:formatNumber>
</a>
