<a href="javascript:;" onclick="showSort()">Show Sort >></a>
<div style="display:${cookie.showSort.value ? 'block' : 'none'}" class="sortHolder">
<input type="text" class="sort1Input" value="${sort1[b.index]}" id="colPrimarySort${b.index}" placeholder="Sort Field 1">
<input type="text" class="sort1Dir" value="${sort1Direction[b.index]}" id="colPrimarySortDirection${b.index}" placeholder="Direction 1" style="width:65px">
<br>
<input type="text" class="sort2Input" value="${sort2[b.index]}" id="colSecondarySort${b.index}" placeholder="Sort Field 2">
<input type="text" class="sort2Dir" value="${sort2Direction[b.index]}" id="colSecondarySortDirection${b.index}" placeholder="Direction 2" style="width:65px">
<br>
</div>