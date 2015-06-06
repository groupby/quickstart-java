<%@include file="tags.jsp"%>
<b><a class="deleteCheckbox" href="<c:url value="${b:toUrlRemove('default', results.query, results.selectedNavigation, navigation.name, refinement)}"/>">x</a>
<c:out value="${navigation.displayName}"/></b>: <c:out value="${refinement.value}"/>
