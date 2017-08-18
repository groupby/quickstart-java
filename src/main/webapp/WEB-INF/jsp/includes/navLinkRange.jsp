<%@include file="tags.jsp"%>

<div class="nav-group ">
  <div class="nav-heading">
    <span class="nav-name">${nav.displayName}</span>
    <span class="nav-info" data-tooltip="${nav.name}">?</span>
    <%@include file="navMetadata.jsp"%>
  </div>
  <div class="facet-holder">
    <c:forEach items="${nav.refinements}" var="value">
      <a class="facet" href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, nav.name, value)}"/>">
        <span class="facet-value">
          <fmt:formatNumber pattern="0.00">${value['low']}</fmt:formatNumber>
            ${empty value['high'] ? '+' : '-'}
          <fmt:formatNumber pattern="0.00">${value['high']}</fmt:formatNumber>
        </span>
        <span class="facet-count"><fmt:formatNumber>${value['count'] }</fmt:formatNumber></span>
      </a>
    </c:forEach>
  </div>
</div>
