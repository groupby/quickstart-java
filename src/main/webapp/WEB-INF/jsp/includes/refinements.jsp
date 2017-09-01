<%@include file="tags.jsp"%>
<div class="refinements">
  <span>Refined by: </span>
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

        <c:if test="${!empty results.query}">
          <div class="refinements__item refinements__item--term">
            <a href="<c:url value="${b:toUrlAdd('default', '', results.selectedNavigation, navigation.name, null)}"/>">
              <span class="deleteCheckbox">x</span>
              <c:out value="${results.query}"/>
            </a>
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
  <div class="refinements__add">
    <a href="javascript:;" onclick="addAnyNav()" title="Add any Navigation">+ Add Refinements</a>
  </div>
</div>
