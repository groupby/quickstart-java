<%@include file="tags.jsp"%>

<div id="nav-${nav.name}" class="nav-group">
<c:if test="${nav['or']}">
    <div class="nav-heading">
      <div class="nav-name">${nav.displayName}</div>
      <div  class="nav-info"
            data-tooltip="Data Name: ${nav.name} - (OR)&#13
            <%@include file="navMetadata.jsp"%>">?</div>

    </div>
    <div id="facet-${nav.name}" class="facet-holder">
        <c:forEach items="${nav.refinements}" var="value">
          <c:if test="${!gc:isRefinementSelected(results, nav.name, value.value)}">
            <a class="facet" href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, nav.name, value)}"/>">
              <span class="facet-check">&#x2610;</span>
              <span class="facet-value">${value.value}</span>
              <span class="facet-count">(<fmt:formatNumber>${value['count'] }</fmt:formatNumber>)</span>
            </a>
          </c:if>
          <c:if test="${gc:isRefinementSelected(results, nav.name, value.value)}">
            <a class="selected facet" href="<c:url value="${b:toUrlRemove('default', results.query, results.selectedNavigation, nav.name, value)}"/>">
              <span class="facet-check">&#x2611;</span>
              <span class="facet-value">${value.value}</span>
              <span class="facet-count">(<fmt:formatNumber>${value['count'] }</fmt:formatNumber>)</span>
            </a>
          </c:if>
        </c:forEach>
    </div>
</c:if>
<c:if test="${!nav['or']}">
  <div class="nav-heading">
    <span class="nav-name">${nav.displayName}</span>
    <div  class="nav-info"
          data-tooltip="Data Name: ${nav.name}
          <%@include file="navMetadata.jsp"%>">?</div>
  </div>
		<div id="facet-${nav.name}" class="facet-holder">
			<c:forEach items="${nav.refinements}" var="value">
				<a class="facet" href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, nav.name, value)}"/>">
          <div class="facet-value">${value.value}</div>
          <div class="facet-count">(<fmt:formatNumber>${value['count'] }</fmt:formatNumber>)</div>
        </a>
			</c:forEach>
		</div>
</c:if>
<c:if test="${nav.isMoreRefinements()}">
	<div class="nav-more" id="more-${nav.id}">
		<a href="javascript:;" onclick="getMoreNav('${nav.name}')" class="btn sml rnd">View More</a>
	</div>
</c:if>

</div>
