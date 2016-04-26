<c:forEach items="${results.records}" var="record" varStatus="i">
    <li class="record highlightCorresponding h${record.id}" data-id="row${b.index}.h${record.id}">
        <h2>Record ${i.index + results.pageInfo.recordStart}</h2>
        <div class="details">
            <c:forEach items="${record.allMeta}" var="entry">
                <c:if test="${!(fn:startsWith(entry.value, '[{') || fn:startsWith(entry.value, '{'))}">
                  <div class="keyValue"><span class="key">${entry.key}</span>:
                      <span class="value">${entry.value }</span></div>
                </c:if>
                <c:if test="${fn:startsWith(entry.value, '[{') || fn:startsWith(entry.value, '[{')}">
                    <div class="keyValue"><span class="key">${entry.key}</span>:
                        <span class="value reformatJson">${entry.value }</span></div>
                </c:if>
            </c:forEach>
            <c:forEach items="${record.allMeta}" var="entry">
                <c:if test="${fn:contains(entry.key, 'image') or fn:endsWith(fn:toLowerCase(entry.value), '.jpg') or fn:endsWith(fn:toLowerCase(entry.value), '.jpeg') or fn:endsWith(fn:toLowerCase(entry.value), '.png') or fn:endsWith(fn:toLowerCase(entry.value), '.gif')}">
                    ${entry.key}:
                    <img style="display: inline-block; max-width: 200px; max-height: 200px; margin: 5px;" src="${entry.value}"/>
                </c:if>
            </c:forEach>
        </div>
    </li>
</c:forEach>
