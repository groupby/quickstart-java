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
  <div class="refinements__list row">
    <div>Refined by:</div> 
    
      <c:if test="${!empty results.query}">
        <div class="refinements__item refinements__item--term">
          
            <a class="deleteCheckbox" href="<c:url value="${b:toUrlAdd('default', '', results.selectedNavigation, navigation.name, null)}"/>">x</a>
            <c:out value="${results.query}"/>
        
        </div>
      </c:if>

      <c:forEach items="${results.selectedNavigation}" var="navigation">
        
        <c:set var="navigation" value="${navigation}" scope="request"/>
        <c:forEach items="${navigation.refinements}" var="refinement">
          <div class="refinements__item">
            <c:set var="refinement" value="${refinement}" scope="request"/>
            <c:set var="jspInclude">refinementCheckbox${refinement.range ? 'Range' : ''}.jsp</c:set>
            <jsp:include page="includes/${jspInclude}"/>
          </div>
        </c:forEach>
        
      </c:forEach>
    
  </div>

</c:if>
