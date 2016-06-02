<form id="form" accept-charset="UTF-8" action="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, 'selected', null) }"/>">
  <div class="navLink specialNav">
  <a href="javascript:;" onclick="addAnyNav()">+</a>
  </div>
  <input autocomplete="off" type="text" onkeydown="$('#refinements').val('')"
        name="q" id="q" class="cursorFocus" value="${originalQuery.query}" placeholder="Find">
  <input type="hidden" name="refinements" id="refinements" value="${param.refinements }">
  <input type="hidden" name="p" id="p" value="0">
  <input type="submit" value="Find">
  <a id="clear" href="<c:url value="/index.html"/>">Clear search and navigation state</a>
</form>

