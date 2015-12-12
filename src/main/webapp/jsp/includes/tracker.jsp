<%@include file="tags.jsp"%>

<script>
	var _gb = _gb || [], _gbGlobal = {};
	_gb.push('account');

	function generateEvent(sku, purchased){
		var event = {
			session : '<%=session.getId()%>',
			search : '<c:out value="${results.query}"/>',
			recordStart: '${results.pageInfo["recordStart"]}',
			recordEnd: '${results.pageInfo["recordEnd"]}',
			totalRecordCount: '${results.totalRecordCount}',
			refinements: ${results.selectedNavigationJson}
		}
		if(typeof sku != "undefined"){
			event.conversion = sku;
		}
		if(typeof purchased != "undefined"){
			event.purchased = purchased;
		}
		return event;
	}
	_gb.push(generateEvent());

	(function() {
		var ssl = 'https:' == document.location.protocol;
		var s = document.getElementsByTagName('script')[0];
		var gb = document.createElement('script');
		gb.charset = 'UTF-8';
		gb.type = 'text/javascript';
		gb.async = true;
		gb.src = (ssl ? 'https://secure' : 'http://www')
				+ '.groupbycommerce.com/tr.js';
		s.parentNode.insertBefore(gb, s);
	})();

	function sendEvent(sku, purchased){
		gbEvent.send(generateEvent(sku, purchased))
	}
</script>
