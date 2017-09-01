<%@include file="tags.jsp"%>
<c:set var="navString">
  <c:forEach items="${results.availableNavigation}" var="nav">
    <c:set var="nav" value="${nav }" scope="request"/>
    <c:set var="jspInclude">includes/navLink${nav.range ? 'Range' : '' }.jsp</c:set>
    <jsp:include page="${jspInclude}"/>
  </c:forEach>
</c:set>
<c:if test="${!empty navString}">
  ${navString}
</c:if>
<c:if test="${empty navString}">
  <div class="nav-group">
    <span class="no-navs">No refinements available</span>
  </div>
</c:if>
