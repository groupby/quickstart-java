<%@include file="tags.jsp"%>

<c:set var="navString">
  <c:forEach items="${results.availableNavigation}" var="nav">
    <c:set var="nav" value="${nav }" scope="request"/>
    <c:set var="jspInclude">includes/navLink${nav.range ? 'Range' : '' }.jsp</c:set>
    <jsp:include page="${jspInclude}"/>
    <c:if test="${!empty nav.metadata}">
     <div class="navigationMetadataTitle">
      metadata:
      <c:forEach items="${nav.metadata}" var="meta">
       <br>
       <div class="navigationMetadata">
        ${meta.key} : ${meta.value}
       </div>
      </c:forEach>
     </div>
    </c:if>
  </c:forEach>  
</c:set>
<c:if test="${!empty navString}">
  ${navString}
</c:if>
<c:if test="${empty navString}">
  <b>No refinements remain</b>
</c:if>