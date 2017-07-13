
<%@include file="includes/tags.jsp"%>
<%@include file="includes/searchBar.jsp"%>
<div class="results row--solid">
        <div class="navigation _20">
          <%@include file="includes/navigation.jsp"%>
        </div>
        <div class="state">
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
        </div>
  
</div>
