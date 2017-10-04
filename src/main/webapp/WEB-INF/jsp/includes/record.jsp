<c:forEach items="${results.records}" var="record" varStatus="i">
    <c:set var="excludes">
    id, title, ${!empty cookie.imageField.value ? cookie.imageField.value : ''}${!empty cookie.imageField.value ? ',' : ''}</c:set>
    <li class="record highlightCorresponding h${record.id}" data-id="row${b.index}.h${record.id}">
        <div data-id="${i.count}" class="record-title">
            <span class="record-name">Record ${i.index + results.pageInfo.recordStart}</span>
            <span class="id">id: <c:out value="${record.allMeta['id']}"/></span>
            <span class="otherColumns">&nbsp;</span>
        </div>

        <div class="details">


            <c:if test="${empty cookie.imageField}">
                <div class="image-list row">
                    <c:forEach items="${record.allMeta}" var="entry">
                        <c:if test="${fn:contains(entry.key, 'image') or fn:endsWith(fn:toLowerCase(entry.value), '.jpg') or fn:endsWith(fn:toLowerCase(entry.value), '.jpeg') or fn:endsWith(fn:toLowerCase(entry.value), '.png') or fn:endsWith(fn:toLowerCase(entry.value), '.gif')}">
                            <div class="image-holder">

                                <img src="${entry.value}"/>
                                <span>${entry.key}</span>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </c:if>
            <c:if test="${!empty record.allMeta['gbiInjectedImage']}">
              <div class="keyValue">
                  <div class="image-holder">
                    <img src="${URLDecoder.decode(cookie.imagePrefix.value)}<c:out value="${record.allMeta['gbiInjectedImage']}"/>${URLDecoder.decode(cookie.imageSuffix.value)}"/>
                    <span class="key">${URLDecoder.decode(cookie.imageField.value)}:</span>
                    <span class="value"><c:out value="${record.allMeta['gbiInjectedImage']}"/></span>
                  </div>
              </div>
            </c:if>
            <div class="keyValue"><span class="key">title:</span> <span class="value">${record.allMeta['title'] }</span></div>
            <c:forEach items="${record.allMeta}" var="entry">
              <c:set var="entryKey">${entry.key},</c:set>
              <c:if test="${!fn:contains(excludes, entryKey)}">
                <div class="keyValue">
                    <span class="key">${entry.key}:</span>
                    <c:if test="${!(fn:startsWith(entry.value, '[') || fn:startsWith(entry.value, '{'))}"><span class="value"><c:out value="${entry.value}"/></span></c:if>
                    <c:if test="${fn:startsWith(entry.value, '[') || fn:startsWith(entry.value, '{')}"><span class="value jsonValue" style="display:${cookie.raw.value ? 'block' : 'none'}"><c:out value="${Mappers.writeValueAsString(entry.value)}"/></span></c:if>
                </div>
              </c:if>
            </c:forEach>


        </div>
    </li>
</c:forEach>
