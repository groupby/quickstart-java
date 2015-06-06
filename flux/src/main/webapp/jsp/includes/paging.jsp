<div class="page">
 	<c:if test="${results.totalRecordCount>=0 && results.pageInfo.recordStart > 1}">
		<c:set var="page_to_go_back" value="${results.pageInfo.recordStart-11}"></c:set>
			<c:if test="${page_to_go_back>0}">
				<a href="javascript:;" onclick="$('#p').val('${page_to_go_back}');$('#form').submit()">Prev Page</a>
			</c:if>
			<c:if test="${page_to_go_back<=0}">
				<a href="javascript:;" onclick="$('#p').val('0');$('#form').submit()">Prev Page</a>
			</c:if>
	</c:if>
 	<c:if test="${results.totalRecordCount>0 && results.pageInfo.recordEnd < results.totalRecordCount}">
		<a href="javascript:;" onclick="$('#p').val('${results.pageInfo.recordEnd}');$('#form').submit()">Next Page</a>
	</c:if>
</div>
