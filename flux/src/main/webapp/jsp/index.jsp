<%@include file="includes/tags.jsp"%>
<!DOCTYPE html>
<html>
<c:set var="title">RefApp</c:set>
<%@include file="includes/tagHead.jsp"%>
<body>

<c:set var="results" value="${model.results0}" scope="request"/>
<c:set var="originalQuery" value="${model.originalQuery0}" scope="request"/>
<c:set var="customerId" value="${model.customerId}" scope="request"/>
<%@include file="includes/form.jsp"%>

  <c:if test="${!empty results.redirect}">
    Found redirect: <c:out value="${results.redirect}"/>
  </c:if>
  
  
  <div class="container">
    <div class="controls">
      <c:if test="$!empty param.q}">
      <h1>Search results for ${param.q }</h1>
      </c:if>
      <%@include file="includes/didYouMean.jsp"%>
      <%@include file="includes/refinements.jsp"%>


      <br> <br>
      <%@include file="includes/paging.jsp"%>
      <%@include file="includes/recordCount.jsp"%>
    </div>
            <c:choose>
      <c:when test="${results.template.name eq 'Famous Person Landing Page'}">
        <jsp:include  page="famous.jsp"/>
      </c:when>
      <c:when test="${results.template.name eq 'default' or empty results.template.name}">
        <jsp:include  page="default.jsp"/>
      </c:when>
      <c:otherwise>
        <h2>Landing page not defined: "${results.template.name}"</h2>
        <jsp:include  page="default.jsp"/>
      </c:otherwise>
    </c:choose>
    

  </div>
  <script src="<c:url value="/js/main.js"/>"></script>
</body>
<%--<%@include file="includes/tracker.jsp"%>--%>
</html>

