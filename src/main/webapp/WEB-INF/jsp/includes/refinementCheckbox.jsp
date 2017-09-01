<%@include file="tags.jsp"%>
<a href="<c:url value="${b:toUrlRemove('default', results.query, results.selectedNavigation, navigation.name, refinement)}"/>">
  <span class="deleteCheckbox">x</span> <c:out value="${navigation.displayName}"/>: <c:out value="${refinement.value}"/>
</a>
