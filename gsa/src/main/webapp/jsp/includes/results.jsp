<%@include file="tags.jsp"%>

<c:forEach items="${results.records}" var="record" varStatus="i">

  <div class="record">
    <h2>Record ${i.index + results.pageInfo.recordStart}</h2>
    <div class="details">
      <c:forEach items="${record.allMeta}" var="entry">
        <div class="keyValue"><span class="key">${entry.key}</span>:
        <span class="value">${entry.value }</span></div>
      </c:forEach>
      <c:forEach items="${record.allMeta}" var="entry">
        <c:if test="${fn:endsWith(entry.value, '.jpg') or fn:endsWith(entry.value, '.jpeg') or fn:endsWith(entry.value, '.png') or fn:endsWith(entry.value, '.gif')}">
        ${entry.key}:
        <img style="display: inline-block; max-width: 200px; max-height: 200px; margin: 5px;" src="${entry.value }"/>
        </c:if>
      </c:forEach>
    </div>
  </div>
  <br>
</c:forEach>