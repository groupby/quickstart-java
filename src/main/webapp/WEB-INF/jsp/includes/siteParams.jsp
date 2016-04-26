<%@include file="tags.jsp"%>

<c:if test="${not empty results.siteParams}">
  Site Parameters:
  <c:forEach items="${results.siteParams}" var="p">
	<div class="sitewideMetadata">
	  ${p.key} : ${p.value}
    </div>
  </c:forEach>
  <hr>
</c:if>