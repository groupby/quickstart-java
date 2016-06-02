<c:if test="${!empty nav.metadata}">
 <div class="navigationMetadataTitle">
  metadata:
  <c:forEach items="${nav.metadata}" var="meta">
   <div class="navigationMetadata">
    <b>${meta.key}</b> : ${meta.value}
   </div>
  </c:forEach>
 </div>
</c:if>