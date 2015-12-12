<%@include file="tags.jsp"%>

<c:if test="${fn:length(results.selectedNavigation) > 0 or !empty results.query}">
  <script>
  	function uncheckrefinement(){
  		$('#refinements').val('');
  		$('#refinementsDiv input[type=checkbox]:checked').each(function(){
  			$('#refinements').val($('#refinements').val() + "~" + $(this).attr('value'));
  		});
  		$('#form').submit();
  	}
  </script>
  <div id="refinementsDiv">
  Refined by:

  <c:if test="${!empty results.query}">
      <b>
        <a class="deleteCheckbox" href="<c:url value="${b:toUrlAdd('default', '', results.selectedNavigation, 'selected', null)}"/>">x</a>
        <c:out value="${results.query}"/>
  	  </b>

  </c:if>
  <c:forEach items="${results.selectedNavigation}" var="navigation">
    <c:set var="navigation" value="${navigation}" scope="request"/>
    <c:forEach items="${navigation.refinements}" var="refinement">
      <c:set var="refinement" value="${refinement}" scope="request"/>
      <c:set var="jspInclude">refinementCheckbox${refinement.range ? 'Range' : ''}.jsp</c:set>
      <jsp:include page="includes/${jspInclude}"/>
    </c:forEach>
  </c:forEach>
  </div>
</c:if>
