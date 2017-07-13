<%@include file="tags.jsp"%>

<div id="nav-${nav.name}" class="navLink">
<c:if test="${nav['or']}">
    <b>${nav.displayName}
    <span class="attribute">${nav.name} (OR)</span>
    <%@include file="navMetadata.jsp"%>
    </b>


    <div class="nav-${nav.name} refinementsHolder">
        <c:forEach items="${nav.refinements}" var="value">
            <div>
                <c:if test="${!gc:isRefinementSelected(results, nav.name, value.value)}">

                    <div>
                        <a href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, nav.name, value)}"/>">&#x2610; ${value.value}
                            <span class="count">(<fmt:formatNumber>${value['count'] }</fmt:formatNumber>)</span>
                        </a>
                        
                    </div>
                </c:if>
                <c:if test="${gc:isRefinementSelected(results, nav.name, value.value)}">
                    <div>
                        <a class="selected" href="<c:url value="${b:toUrlRemove('default', results.query, results.selectedNavigation, nav.name, value)}"/>">&#x2611; ${value.value}
                            <span class="count">(<fmt:formatNumber>${value['count'] }</fmt:formatNumber>)</span>
                        </a>
                        
                    </div>
                </c:if>
            </div>
        </c:forEach>
    </div>
</c:if>
<c:if test="${!nav['or']}">
		<b>${nav.displayName}
		<span class="attribute">${nav.name}</span>
		<%@include file="navMetadata.jsp"%>
		</b>
		<div class="nav-${nav.name} refinementsHolder">
			<c:forEach items="${nav.refinements}" var="value">
				<div>
					<a href="<c:url value="${b:toUrlAdd('default', results.query, results.selectedNavigation, nav.name, value)}"/>">${value.value} 
                    <span class="count">(<fmt:formatNumber>${value['count'] }</fmt:formatNumber>)</span>
                    </a>
                    
				</div>
			</c:forEach>
		</div>
</c:if>

<c:if test="${nav.isMoreRefinements()}">
	<div class="moreLink" id="more-${nav.id}">
		<a href="javascript:;" onclick="getMoreNav('${nav.name}')">More [+]</a>
	</div>
</c:if>
</div>