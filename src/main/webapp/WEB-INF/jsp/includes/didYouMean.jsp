<%@include file="tags.jsp"%>

<c:if test="${fn:length(results.didYouMean) > 0}">
  Did you mean:
  <c:forEach items="${results.didYouMean}" var="didYouMean">
    <a href="<c:url value="${b:toUrlAdd('default', didYouMean, results.selectedNavigation, navigation.name, null) }"/>">${didYouMean }</a>?
  </c:forEach>
</c:if>

<c:if test="${fn:length(results.relatedQueries) > 0}">
  Related:
  <c:forEach items="${results.relatedQueries}" var="relatedQuery">
    <a href="<c:url value="${b:toUrlAdd('default', relatedQuery, results.selectedNavigation, navigation.name, null) }"/>">${relatedQuery}</a>
  </c:forEach>
</c:if>