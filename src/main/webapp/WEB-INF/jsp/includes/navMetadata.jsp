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