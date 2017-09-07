<c:if test="${results.totalRecordCount > 0 }">
  <div class="record-count _50">
    Showing Records ${results.pageInfo['recordStart']} - ${results.pageInfo['recordEnd']} of <fmt:formatNumber pattern="#,###">${results.totalRecordCount}</fmt:formatNumber><c:if test="${recordLimitReached}">+</c:if>
    <a href="javascript:;" onclick="showColumnSpecifics()" class="btn sml">View Details</a>
  </div>
</c:if>

<c:if test="${results.totalRecordCount == 0 }">
  <div class="no-results">
    <span class="no-results-text">No records found for ${results.query }</span>
    <a href="javascript:;" onclick="showColumnSpecifics()" class="btn sml">View Details</a>
  </div>
</c:if>
