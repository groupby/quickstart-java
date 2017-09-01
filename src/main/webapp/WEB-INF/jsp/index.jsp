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
      <jsp:include  page="default.jsp"/>
    </div>
    <script>
    <%@include file="/js/main.js"%>
    </script>
  </body>
  <%--<%@include file="includes/tracker.jsp"%>--%>
</html>
