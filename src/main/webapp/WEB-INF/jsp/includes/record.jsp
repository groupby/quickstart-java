<c:forEach items="${results.records}" var="record" varStatus="i">
    <c:set var="excludes">
    id, title, ${!empty cookie.imageField.value ? cookie.imageField.value : ''}${!empty cookie.imageField.value ? ',' : ''}</c:set>
    <li class="record highlightCorresponding h${record.id}" data-id="row${b.index}.h${record.id}">
        <h2 data-id="${i.count}">Record ${i.index + results.pageInfo.recordStart}
            <span class="id">id: <c:out value="${record.allMeta['id']}"/></span>
            <span class="otherColumns" style="display:inline-block"></span>
        </h2>
        <div class="details">
            <div class="keyValue"><span class="key">title</span>:<span class="value">${record.allMeta['title'] }</span></div>
            <c:forEach items="${record.allMeta}" var="entry">
              <c:set var="entryKey">${entry.key},</c:set>
              <c:if test="${!fn:contains(excludes, entryKey)}">
                  <div class="keyValue"><span class="key">${entry.key}</span>:
                  <c:if test="${!(fn:startsWith(entry.value, '[') || fn:startsWith(entry.value, '{'))}">
                  <span class="value">${entry.value }</span></div>
                  </c:if>
                  <c:if test="${fn:startsWith(entry.value, '[') || fn:startsWith(entry.value, '{')}">
                    <span class="value jsonValue" style="display:${cookie.raw.value ? 'block' : 'none'}"><c:out value="${Mappers.writeValueAsString(entry.value)}"/></span></div>
                  </c:if>
              </c:if>
            </c:forEach>

            <c:if test="${empty cookie.imageField}">
                <c:forEach items="${record.allMeta}" var="entry">
                    <c:if test="${fn:contains(entry.key, 'image') or fn:endsWith(fn:toLowerCase(entry.value), '.jpg') or fn:endsWith(fn:toLowerCase(entry.value), '.jpeg') or fn:endsWith(fn:toLowerCase(entry.value), '.png') or fn:endsWith(fn:toLowerCase(entry.value), '.gif')}">
                        ${entry.key}:
                        <img style="display: inline-block; max-width: 200px; max-height: 200px; margin: 5px;" src="${entry.value}"/>
                    </c:if>
                </c:forEach>
            </c:if>
            <c:if test="${!empty record.allMeta['gbiInjectedImage']}">
              <div class="keyValue"><span class="key">${cookie.imageField.value}</span>:
              <span class="value"><c:out value="${record.allMeta['gbiInjectedImage']}"/></span></div>
              <img style="display: inline-block; max-width: 200px; max-height: 200px; margin: 5px;" src="${URLDecoder.decode(cookie.imagePrefix.value)}<c:out value="${record.allMeta['gbiInjectedImage']}"/>${URLDecoder.decode(cookie.imageSuffix.value)}"/>
            </c:if>
        </div>
    </li>
</c:forEach>
