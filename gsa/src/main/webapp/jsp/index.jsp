<%@include file="includes/tags.jsp"%>
<!DOCTYPE html>
<html>
<c:set var="title">RefApp</c:set>
<%@include file="includes/tagHead.jsp"%>
<body>

  <%@include file="includes/form.jsp"%>
  
  <c:if test="${!empty results.redirect}">
    <c:redirect url="${results.redirect}"/> 
  </c:if>
  
  
  <div class="container">
    <div class="controls">
      <c:if test="$!empty param.q}">
      <h1>Search results for ${param.q }</h1>
      </c:if>
      <%@include file="includes/debug.jsp"%>
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
      <c:when test="${results.template.name eq 'default'}">
        <jsp:include  page="default.jsp"/>
      </c:when>
      <c:otherwise>
        <h2>Landing page not defined: "${results.template.name}"</h2>
        <jsp:include  page="default.jsp"/>
      </c:otherwise>
    </c:choose>
    

  </div>
</body>
<%--<%@include file="includes/tracker.jsp"%>--%>
</html>

