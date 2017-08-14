<c:if test="${!empty nav.metadata}">

  metadata:
  <c:forEach items="${nav.metadata}" var="meta">

    <b>${meta.key}</b> : ${meta.value}

  </c:forEach>

</c:if>
