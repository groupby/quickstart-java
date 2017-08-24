<div class="search-bar">

  <form id="form" class="search-bar__form" accept-charset="UTF-8" action="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, 'selected', null) }"/>">
  <span class="search-bar__icon">

  </span>
    <input  autocomplete="off"
            type="text" onkeydown="$('#refinements').val('')"
            name="q"
            id="q"
            class="search-bar__input"
            value="<c:out value="${originalQuery.query}"/>"
            placeholder="Find">
    <input type="hidden" name="refinements" id="refinements" value="<c:out value="${param.refinements }"/>">
    <input type="hidden" name="p" id="p" value="0">
    <button type="submit" class="search-bar__button" title="Execute Query">
      <svg xmlns="http://www.w3.org/2000/svg" width="16px" height="16px" viewBox="0 0 511.993 511.993"><path d="M501.251 414.845L379.813 313.626a225.987 225.987 0 0 1-66.156 66.188l101.188 121.438c11.25 13.5 30.656 14.406 43.095 1.969l45.28-45.28c12.437-12.44 11.531-31.846-1.969-43.096zM384.001 192c0-106.031-85.969-192-192-192s-192 85.969-192 192c0 106.032 85.969 192 192 192 106.031.001 192-85.968 192-192zM192 336.001c-79.406 0-144-64.594-144-144s64.594-144 144-144c79.407 0 144 64.594 144 144 .001 79.406-64.593 144-144 144z"/></svg>
    </button>
  </form>
  <a id="clear" href="<c:url value="/index.html"/>" class="search-bar__clear">Clear search and navigation state</a>
</div>
