<c:if test="${!empty nav.metadata}">
  Metadata:&#13
  <c:forEach items="${nav.metadata}" var="meta">
  ${meta.key} = ${meta.value}&#13
  </c:forEach>
</c:if>
