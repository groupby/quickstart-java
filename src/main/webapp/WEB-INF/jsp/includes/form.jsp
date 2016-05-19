<div class="header">

<form id="cookieForm">
  <img align="right" src="<c:url value="/images/logo.png"/>" height="27px"/>
  <c:if test="${!empty customerId}">
    <a target="_blank" id="commandCenterLink" href="https://${customerId}.groupbycloud.com/admin/keyManagement.html">Command Center</a>
  </c:if>
  <input type="text" name="clientKey" id="clientKey" placeholder="Client Key" value="${param.clientKey}" style="width:260px;">
  <input type="text" name="customerId" id="customerId" placeholder="Customer ID" value="${param.customerId}" style="width:120px"> |
  <input type="text" name="area" id="area" placeholder="Area" style="width:60px">
  <input type="text" name="collection" id="collection" placeholder="Collection" style="width:80px">
  <input type="text" name="language" id="language" placeholder="Language" style="width:80px"> |
  <input type="text" name="sortField" id="sortField" placeholder="Sort Field" style="width:100px;margin-top:10px">
  <input type="text" name="sortOrder" id="sortOrder" placeholder="Sort Order (A or D)" style="width:150px;margin-top:10px">
  <label for="skipCache"><input type="checkbox" name="skipCache" id="skipCache">Skip Cache</label>
  <br />
  <input type="text" name="includedNavigations" id="includedNavigations" placeholder="Included Navigations" style="width:125px;margin-top:10px">
  <input type="text" name="excludedNavigations" id="excludedNavigations" placeholder="Excluded Navigations" style="width:125px;margin-top:10px">
  <br />
  <input type="text" name="fields" id="fields" placeholder="Field List, comma separated" style="width:750px;margin-top:10px"><br />
  <input type="text" name="bringToTop" id="bringToTop" placeholder="Bring To Top, comma separated list of Product IDs" style="width:750px;margin-top:10px">
  <br />
  <input type="hidden" name="biasingProfile" id="biasingProfile">
</form>
</div>
<form id="form" accept-charset="UTF-8" action="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, 'selected', null) }"/>">
  <input autocomplete="off" type="text" onkeydown="$('#refinements').val('')"
        name="q" id="q" class="cursorFocus" value="${originalQuery.query}" placeholder="Search">
  <input type="hidden" name="refinements" id="refinements" value="${param.refinements }">
  <input type="hidden" name="p" id="p" value="0">
  <input type="submit" value="Search">
  <a id="clear" href="<c:url value="/index.html"/>">Clear Search and Nav</a>
</form>


<script>

    var currentHash = location.hash;
    if (currentHash){
        var hashes = currentHash.substring(1).split('&');
        hashes.forEach(function(pItem){
            var keyValue = pItem.split('=');
            if (keyValue && keyValue.length == 2 && keyValue[0] && keyValue[1] && keyValue[1] !== 'undefined') {
                $('#' + keyValue[0]).attr('value', keyValue[1]);
                $.cookie(keyValue[0], keyValue[1]);
            }
        });
    }
    var customerIdFromRequestScopeExists = ${!empty customerId};
    if ($('#customerId').attr('value') && !customerIdFromRequestScopeExists){
        self.location.reload();
    }

    $('#cookieForm input').each(function(){
        $(this).keypress(function(e) {
            var code = (e.keyCode ? e.keyCode : e.which);
             if (code == 13) {
                e.preventDefault();
                e.stopPropagation();
                saveForm();
                $('#form').submit();
             }
         });
    });
    function saveForm() {
        var hashLocation = '';
        $('#cookieForm input').each(function(){
            var myId = $(this).attr('id');
            var type = $(this).attr('type');
            if ($.cookie(myId)) {
                if (type === 'text'){
                  $(this).val($.cookie(myId));
                }
                if (type === 'checkbox'){
                  $(this).prop("checked", $.cookie(myId) === 'true');
                }
                hashLocation += myId + '=' + $.cookie($(this).attr('id')) + '&';
            }
        });
        location.hash = hashLocation;
    }
    saveForm();
    $('#cookieForm input').bind('keyup blur click change', function(){
        var type = $(this).attr('type');
        if (type === 'text'){
            $.cookie($(this).attr('id'), $(this).val());
        }
        if (type === 'checkbox') {
            $.cookie($(this).attr('id'), $(this).prop('checked'));
        }
        saveForm();
    });

    $('#form').submit(function(e){
        saveForm();
    });
</script>