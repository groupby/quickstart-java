<%@include file="tags.jsp"%>
<b><a class="deleteCheckbox" href="<c:url value="${b:toUrlRemove('default', results.query, results.selectedNavigation, navigation.name, refinement)}"/>">x</a>
<c:out value="${navigation.displayName}"/></b>: <fmt:formatNumber pattern="0.00">${refinement.low}</fmt:formatNumber> ${empty refinement.high ? '+' : ' - '}${empty refinement.high ? '+' : prefix}<fmt:formatNumber pattern="0.00">${refinement.high}</fmt:formatNumber>
