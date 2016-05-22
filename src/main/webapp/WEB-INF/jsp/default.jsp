
<%@include file="includes/tags.jsp"%>
<div class="results">

  <%@include file="includes/siteParams.jsp"%>
  <table width="100%">
    <tr>
      <td width="160" valign="top">
        <div class="navigation">
          <%@include file="includes/navigation.jsp"%>
        </div>
      </td>
      <td valign="top">
        <%@include file="includes/searchBar.jsp"%>
        <div class="state">
          <c:if test="${!empty results.redirect}">
            Found redirect: <c:out value="${results.redirect}"/>
          </c:if>
            <%@include file="includes/didYouMean.jsp"%>
            <%@include file="includes/refinements.jsp"%>
            <div id="recordAndPaging">
                <table width="100%"><tr><td>
                <%@include file="includes/recordCount.jsp"%>
                </td><td>
                <%@include file="includes/paging.jsp"%>
                </td></tr></table>
            </div>
            <%@include file="includes/results.jsp"%>
        </div>
      </td>
    </tr>
  </table>


</div>
