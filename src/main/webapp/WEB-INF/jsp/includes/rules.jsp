
<div id="ruleFired" class="rules-area">
  <span id="ruleTitle">Rule fired: ${results.template.ruleName} (Template: ${results.template.name})
    <a href="javascript:;" onclick="showZones()" class="btn scnd">show zones</a>
  </span>
  <section id="allZones" style="display:${cookie.showZones.value ? 'block' : 'none'}" class="zone-response">
    <c:if test="${fn:length(results.template.zones) == 0}">
      No zones
    </c:if>
    <c:if test="${fn:length(results.template.zones) > 0}">
      <c:forEach items="${results.template.zones}" var="zone" varStatus="zoneStatus">
        <c:set var="zoneType" value="${zone.value['class'].simpleName}"/>
        <c:choose>
          <c:when test="${zoneType == 'ContentZone'}">
            <div class="zone ContentZone">
              <span class="zoneName">Template Zone Name: <strong>${zone.key}</strong></span>
              <div class="zoneValue"><pre><c:out value="${zone.value.content}"/></pre>
              </div>
            </div>
          </c:when>
          <c:when test="${zoneType == 'RichContentZone'}">
            <div class="zone RichContentZone">
              <span class="zoneName">Template Zone Name: <strong>${zone.key}</strong>
                <a href="javascript:;" onclick="$('.zoneValue${zoneStatus.index}').toggle();" class="btn scnd sml">toggle html</a>
              </span>
              <div style="display:none" class="zoneValue zoneValue${zoneStatus.index}">
                <c:out value="${zone.value.richContent}"/>
              </div>
              <div class="zoneValue zoneValue${zoneStatus.index}">
                ${zone.value.richContent}
              </div>
            </div>
          </c:when>
          <c:when test="${zoneType == 'RecordZone'}">
            <div class="zone RecordZone">
              <span class="zoneName">Template Zone Name: <strong>${zone.key}</strong></span>
              <c:if test="${fn:length(zone.value.query) > 0 }">
                <span class="zoneName">Search term used for the Zone: <a href="<c:url value="${b:toUrlAdd('default', zone.value.query, results.selectedNavigation, navigation.name, null) }"/>"><strong>${zone.value.query}</strong></a></span>
              </c:if>
              <div class="zoneValue jsonValue">
                <c:out value="${Mappers.writeValueAsString(zone.value.records)}"/>
              </div>
            </div>
          </c:when>
        </c:choose>
      </c:forEach>
    </c:if>
  </section>
</div>
