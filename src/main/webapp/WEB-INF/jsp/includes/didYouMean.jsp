<%@include file="tags.jsp"%>

<c:if test="${fn:length(results.didYouMean) > 0}">
  <div class="did-you-mean">
    <span>Did you mean:</span>
    <c:forEach items="${results.didYouMean}" var="didYouMean">
      <a href="<c:url value="${b:toUrlAdd('default', didYouMean, results.selectedNavigation, navigation.name, null) }"/>">${didYouMean }</a>?
    </c:forEach>
  </div>
</c:if>

<c:if test="${fn:length(results.relatedQueries) > 0}">
  <div class="related-query">
    <span>Related:</span>
    <c:forEach items="${results.relatedQueries}" var="relatedQuery">
      <a href="<c:url value="${b:toUrlAdd('default', relatedQuery, results.selectedNavigation, navigation.name, null) }"/>">${relatedQuery}</a>
    </c:forEach>
  </div>
</c:if>
