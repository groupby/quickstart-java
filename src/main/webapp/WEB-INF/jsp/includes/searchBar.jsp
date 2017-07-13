<form id="form" class="search-bar row" accept-charset="UTF-8" action="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, 'selected', null) }"/>">
  
  <input  autocomplete="off" 
          type="text" onkeydown="$('#refinements').val('')"
          name="q" 
          id="q" 
          class="cursorFocus grow big" 
          value="<c:out value="${originalQuery.query}"/>" 
          placeholder="Find">
  <input type="hidden" name="refinements" id="refinements" value="<c:out value="${param.refinements }"/>">
  <input type="hidden" name="p" id="p" value="0">
  <input type="submit" value="Find" class="">
  <a id="clear" href="<c:url value="/index.html"/>" class="btn scnd">Clear search and navigation state</a>
  <a href="javascript:;" onclick="addAnyNav()" title="Add any Navigation" class="btn rnd">+</a>
  
</form>

