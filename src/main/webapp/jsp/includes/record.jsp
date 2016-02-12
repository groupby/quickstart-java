<c:forEach items="${results.records}" var="record" varStatus="i">
    <li class="record highlightCorresponding h${record.id}" data-id="row${b.index}.h${record.id}">
        <h2>Record ${i.index + results.pageInfo.recordStart}</h2>
        <div class="details">
        	<ul>
		<c:forEach items="${record.allMeta}" var="entry"> 
			<c:if test="${!(fn:startsWith(entry.value, '[{') || fn:startsWith(entry.value, '{'))}">
				<li><b>${entry.key}:</b> ${entry.value}</li>	
			</c:if>
			<c:if test="${fn:startsWith(entry.value, '[{') || fn:startsWith(entry.value, '[{')}">
				<li><b>${entry.key}:</b> ${entry.value }</li>
			</c:if>
			<c:if test="${fn:startsWith(entry.value, '{')}">
				<ul>
				<c:forEach items="${entry.value}" var="entry2">
					<c:if test="${!(fn:startsWith(entry2.value, '[{') || fn:startsWith(entry2.value, '{'))}">
						<li><b>${entry.key}.${entry2.key}:</b> ${entry2.value}</li>
					</c:if>
					<c:if test="${fn:startsWith(entry2.value, '{')}">
						<ul>
						<c:forEach items="${entry2.value}" var="entry3">
							<c:if test="${!(fn:startsWith(entry3.value, '[{') || fn:startsWith(entry3.value, '{'))}">
								<li><b>${entry.key}.${entry2.key}.${entry3.key}:</b> ${entry3.value}</li>
							</c:if>						
							<c:if test="${fn:startsWith(entry3.value, '{') || fn:startsWith(entry3.value, '[{') }">
								<ul>
								<c:forEach items="${entry3.value}" var="entry4">
									<c:if test="${fn:startsWith(entry4, '{') || fn:startsWith(entry4, '[{') }">
										<c:forEach items="${entry4}" var="entry5">
											<li><b>${entry.key}.${entry2.key}.${entry3.key}.${entry5.key}:</b> ${entry5.value}</li>
										</c:forEach>										
									</c:if>
									<c:if test="${!(fn:startsWith(entry4, '[{') || fn:startsWith(entry4, '{'))}">
										<li><b>${entry.key}.${entry2.key}.${entry3.key}.${entry4.key}:</b> ${entry4}</li>				
									</c:if>
								</c:forEach>
								</ul>
							</c:if>
						</c:forEach>
						</ul>
				
					</c:if>
				</c:forEach>
				</ul>
			</c:if>
		</c:forEach>
		<c:forEach items="${record.allMeta}" var="entry">
			<c:if test="${fn:contains(entry.key, 'image') or fn:endsWith(fn:toLowerCase(entry.value), '.jpg') or fn:endsWith(fn:toLowerCase(entry.value), '.jpeg') or fn:endsWith(fn:toLowerCase(entry.value), '.png') or fn:endsWith(fn:toLowerCase(entry.value), '.gif')}">
				${entry.key}:
				<img style="display: inline-block; max-width: 200px; max-height: 200px; margin: 5px;" src="${entry.value}"/>
			</c:if>
		</c:forEach>
		</ul>
        </div>
    </li>
</c:forEach>

