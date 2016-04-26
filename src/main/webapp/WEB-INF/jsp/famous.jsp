<%@include file="includes/tags.jsp"%>

<div class="results">

  <hr>
  <table>
    <tr>
      <td width="160" valign="top">
        <div class="navigation">
          <%@include file="includes/navigation.jsp"%>
        </div>
      </td>
      <td valign="top">
      <div id="famous">
      <img align="left" width="400" src="<c:url value="${results.template.zonesByName['Picture of famous person'].content}"/>"/>
        <div>
          <h2>${results.template.zonesByName['Famous Person Text'].content}</h2>
          <img align="right" src="${results.template.zonesByName['SKU mentioned'].records[0].allMeta.largeImage}"/>
          ${results.template.zonesByName['SKU mentioned'].records[0].title}
        </div>
      </div>
      <br clear="all">
      <%@include file="includes/results.jsp"%></td>
    </tr>
  </table>


</div>