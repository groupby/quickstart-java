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
      <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="16px" height="16px" viewBox="0 0 100 125" enable-background="new 0 0 100 100" xml:space="preserve">
        <path d="M88.895,11.105c-14.807-14.807-38.812-14.807-53.619,0c-14.807,14.806-14.807,38.812,0,53.619
        c14.807,14.807,38.812,14.807,53.619,0S103.702,25.912,88.895,11.105z M84.662,60.492c-12.469,12.468-32.684,12.468-45.153,0
        c-12.468-12.469-12.468-32.685,0-45.153c12.469-12.468,32.685-12.469,45.153,0S97.13,48.022,84.662,60.492z"/>
        <rect x="12.357" y="61.701" transform="matrix(0.7071 0.7071 -0.7071 0.7071 63.1103 10.9445)" width="11.973" height="39.91"/>
      </svg>
    </button>
  </form>
  <a id="clear" href="<c:url value="/index.html"/>" class="search-bar__clear">Clear search and navigation state</a>
</div>
