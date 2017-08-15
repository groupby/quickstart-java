
<%@include file="includes/tags.jsp"%>
<%@include file="includes/searchBar.jsp"%>
<c:set var="results" value="${model.results0}" scope="request"/>
<c:choose>
  <c:when test="${results.template.name eq 'default' or empty results.template.name}">
  </c:when>
  <c:otherwise>
    <%@include file="includes/rules.jsp"%>
  </c:otherwise>
</c:choose>
<div class="results row">

    <section class="navigation">

      <%@include file="includes/navigation.jsp"%>

    </section>
    <a href="javascript:;" onclick="mobileShowNav()" class="mobile-nav-button"><span>Close</span> Filter Results</a>
    <section class="state grow">
      <c:if test="${!empty results.redirect}">
        Found redirect: <c:out value="${results.redirect}"/>
      </c:if>
        <%@include file="includes/didYouMean.jsp"%>
        <%@include file="includes/refinements.jsp"%>
        <div id="recordAndPaging" class="count-paging row">
            <%@include file="includes/recordCount.jsp"%>

            <%@include file="includes/paging.jsp"%>
        </div>
        <%@include file="includes/results.jsp"%>
    </section>
</div>
