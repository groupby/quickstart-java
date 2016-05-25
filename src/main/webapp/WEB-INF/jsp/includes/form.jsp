<div class="header">
<form id="cookieForm">
<div class="customerToolbar">
<span>Customer:</span> ${empty cookie.customerId.value ? 'not set' : cookie.customerId.value}
<span>Area:</span> ${empty cookie.area.value ? 'Production' : cookie.area.value}
<span>Collection:</span> ${empty cookie.collection.value ? 'default' : cookie.collection.value}</a>
</div>
<a href="javascript:;" onclick="showForm()">Show form >></a>
<div id="settings" style="display: ${cookie.showForm.value or empty cookie.clientKey.value or empty cookie.customerId.value ? 'block' : 'none'}">
  <table><tr>
  <td>
  <fieldset>
      <legend>Connection</legend>
      <input type="text" name="customerId" id="customerId" placeholder="Customer ID" style="width:120px">
      <input type="text" name="clientKey" id="clientKey" placeholder="Client Key" style="width:260px;"><br>
      <input type="text" name="collection" id="collection" placeholder="Collection" style="width:180px">
  </fieldset>
  </td><td>
  <fieldset>
      <legend>Area</legend>
      <input type="text" name="area" id="area" placeholder="Area" style="width:160px"><br>
      <input type="text" name="fields" id="fields" placeholder="Field List, comma separated" style="width:450px"><br />
  </fieldset>
  </td>
  </tr></table>
  <a href="javascript:;" onclick="showAdvanced()">Show Advanced >></a>
  <div style="display:${cookie.showAdvanced.value ? 'block' : 'none' }" id="advanced">
  <table><tr>
  <td>

      <fieldset>
          <legend>Language</legend>
          <input type="text" name="language" id="language" placeholder="Language" style="width:80px">
      </fieldset>
      <fieldset>
          <legend>Page Control</legend>
          <label title="If checked, the cache will be used.  This means changes to data and rules will not appear until the cache expires" for="cache"><input type="checkbox" name="cache" id="cache">Use Cache</label><br>
          <input type="text" name="pageSize" id="pageSize" placeholder="Page Size (max 100)" style="width:60px"><br>
      </fieldset>
      <fieldset>
          <legend>Personalized Relevance</legend>
          <input type="text" name="visitorId" id="visitorId" placeholder="Visitor ID" style="width:100px"><br>
      </fieldset>
  </td><td>
      <fieldset>
          <legend>Result Display</legend>
          <label for="raw"><input type="checkbox" name="raw" id="raw">Show Raw</label><br>
          <label for="collapse"><input type="checkbox" name="collapse" id="collapse">Collapse JSON</label><br>
          <input type="text" name="imageField" id="imageField" placeholder="Image Attribute" style="width:120px"><br>
          <input type="text" name="imagePrefix" id="imagePrefix" placeholder="Image Prefix" style="width:120px"><br>
          <input type="text" name="imageSuffix" id="imageSuffix" placeholder="Image Suffix" style="width:120px"><br>
      </fieldset>
  </td><td>
      <fieldset>
          <legend>Result Control</legend>
          <input type="text" name="sortField" id="sortField" placeholder="Sort Field" style="width:100px">
          <input type="text" name="sortOrder" id="sortOrder" placeholder="Order A/D" style="width:60px"><br>
          <input type="text" name="bringToTop" id="bringToTop" placeholder="Bring To Top, comma separated list of Product IDs" style="width:350px"><br>
          <label for="disableAutocorrection"><input type="checkbox" name="disableAutocorrection" id="disableAutocorrection">Disable Autocorrection</label><br>
          <input type="hidden" name="biasingProfile" id="biasingProfile">
          <input type="hidden" name="matchStrategy" id="matchStrategy">

          <c:forEach begin="0" end="4" varStatus="i">
            <input type="hidden" name="colSort${i.count}" id="colSort${i.count}">
            <input type="hidden" name="colDir${i.count}" id="colDir${i.count}">
          </c:forEach>
      </fieldset>

      <fieldset>
          <legend>Navigation Control</legend>
          <input type="text" name="includedNavigations" id="includedNavigations" placeholder="Included Navigations" style="width:125px"><br>
          <input type="text" name="restrictNavigationName" id="restrictNavigationName" placeholder="Restrict by Navigation" style="width:135px">
          <input type="text" name="restrictNavigationCount" id="restrictNavigationCount" placeholder="Count" style="width:55px"><br>
          <label for="dontPruneRefinements"><input type="checkbox" name="dontPruneRefinements" id="dontPruneRefinements">Do not Prune Refinements</label><br>
      </fieldset>
  </td>
  </tr></table>
  </div>
  </div>
</form>
</div>
