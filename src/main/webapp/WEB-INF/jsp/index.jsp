<%@include file="includes/tags.jsp"%>
<!DOCTYPE html>
<html>
<c:set var="title">RefApp</c:set>
<%@include file="includes/tagHead.jsp"%>
<body>

<c:set var="results" value="${model.results0}" scope="request"/>
<c:set var="originalQuery" value="${model.originalQuery0}" scope="request"/>
<c:set var="customerId" value="${model.customerId}" scope="request"/>
<div style="display:none" id="originalQuery"><c:out value="${model.moreRefinementsQuery}"/></div>
<%@include file="includes/form.jsp"%>

  <div class="container">
    <c:choose>
      <c:when test="${results.template.name eq 'default' or empty results.template.name}">
        <jsp:include  page="default.jsp"/>
      </c:when>
      <c:otherwise>
        <div id="ruleFired">
        <div id="ruleTitle">Rule fired: ${results.template.ruleName} (Template: ${results.template.name}) <a href="javascript:;" onclick="showZones()">show zones</a></div>
        <div id="allZones" style="display:${cookie.showZones.value ? 'block' : 'none'}">
        <c:if test="${fn:length(results.template.zones) == 0}">
        <div style="margin-left:5px;">No zones</div>
        </c:if>
        <c:if test="${fn:length(results.template.zones) > 0}">
        <c:forEach items="${results.template.zones}" var="zone" varStatus="zoneStatus">
          <c:set var="zoneType" value="${zone.value['class'].simpleName}"/>
          <c:choose>
          <c:when test="${zoneType == 'ContentZone'}">
              <div class="zone ContentZone">
                <span class="zoneName">Zone name: ${zone.key}</span>
                <div class="zoneValue">
                    <c:out value="${zone.value.content}"/>
                </div>
              </div>
          </c:when>
          <c:when test="${zoneType == 'RichContentZone'}">
              <br clear="all">
              <div class="zone RichContentZone">
                <span class="zoneName">Zone name: ${zone.key} <a href="javascript:;" onclick="$('.zoneValue${zoneStatus.index}').toggle();">toggle html</a></span>
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
              <span class="zoneName">Zone name: ${zone.key}</span>
              <div class="zoneValue jsonValue">
                  <c:out value="${Mappers.writeValueAsString(zone.value.records)}"/>
              </div>
            </div>
          </c:when>
          </c:choose>
        </c:forEach>
        <br clear="both">
        </c:if>
        </div>
        </div>
        <jsp:include  page="default.jsp"/>
      </c:otherwise>
    </c:choose>

  </div>
  <script>
  <%@include file="/js/main.js"%>
  </script>
</body>
<%--<%@include file="includes/tracker.jsp"%>--%>
</html>

