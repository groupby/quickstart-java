<div class="page _50">
 	<c:if test="${results.totalRecordCount>=0 && results.pageInfo.recordStart > 1}">
		<c:set var="page_to_go_back">
		<c:if test="${!empty cookie.pageSize.value}">
            ${results.pageInfo.recordStart-cookie.pageSize.value-1}
		</c:if>
		<c:if test="${empty cookie.pageSize.value}">
            ${results.pageInfo.recordStart-11}
		</c:if>
		</c:set>
			<c:if test="${page_to_go_back>0}">
				<a href="javascript:;" onclick="$('#p').val('${page_to_go_back}');$('#form').submit()" title="Previous Page" class="btn rnd">&lang;</a>
			</c:if>
			<c:if test="${page_to_go_back<=0}">
				<a href="javascript:;" onclick="$('#p').val('0');$('#form').submit()" title="Previous Page" class="btn rnd">&lang;</a>
			</c:if>
	</c:if>
 	<c:if test="${results.totalRecordCount>0 && results.pageInfo.recordEnd < results.totalRecordCount}">
		<a href="javascript:;" onclick="$('#p').val('${results.pageInfo.recordEnd}');$('#form').submit()" title="Next Page" class="btn rnd">&rang;</a>
	</c:if>
</div>
