<%@include file="tags.jsp"%>
<c:if test="${results.totalRecordCount > 0 }">
  <div>Records ${results.pageInfo['recordStart']} - ${results.pageInfo['recordEnd']} of <fmt:formatNumber pattern="#,###">${results.totalRecordCount}</fmt:formatNumber></div>
</c:if>

<c:if test="${results.totalRecordCount == 0 }">
  No records found for ${results.query }
</c:if>