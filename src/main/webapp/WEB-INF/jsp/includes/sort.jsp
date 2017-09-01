<a href="javascript:;" onclick="showSort()" class="btn scnd sml">Set Sort Order</a>
<div style="display:${cookie.showSort.value ? 'block' : 'none'}" class="sortHolder">
    <ul>
        <li>
            <input type="text" class="sortInput sort1Input" value="${sort1[b.index]}" id="colPrimarySort${b.index}" placeholder="Sort Field 1">
            <input type="text" class="sortDir sort1Dir" value="${sort1Direction[b.index]}" id="colPrimarySortDirection${b.index}" placeholder="Direction 1" style="width:65px">
        </li><li>
            <input type="text" class="sortInput sort2Input" value="${sort2[b.index]}" id="colSecondarySort${b.index}" placeholder="Sort Field 2">
            <input type="text" class="sortDir sort2Dir" value="${sort2Direction[b.index]}" id="colSecondarySortDirection${b.index}" placeholder="Direction 2" style="width:65px">
        </li><li>
            <input type="text" class="sortInput sort3Input" value="${sort3[b.index]}" id="colSecondarySort${b.index}" placeholder="Sort Field 3">
            <input type="text" class="sortDir sort3Dir" value="${sort3Direction[b.index]}" id="colSecondarySortDirection${b.index}" placeholder="Direction 3" style="width:65px">
        </li><li>
            <input type="text" class="sortInput sort4Input" value="${sort4[b.index]}" id="colSecondarySort${b.index}" placeholder="Sort Field 4">
            <input type="text" class="sortDir sort4Dir" value="${sort4Direction[b.index]}" id="colSecondarySortDirection${b.index}" placeholder="Direction 4" style="width:65px">
        </li><li>
            <input type="text" class="sortInput sort5Input" value="${sort5[b.index]}" id="colSecondarySort${b.index}" placeholder="Sort Field 5">
            <input type="text" class="sortDir sort5Dir" value="${sort5Direction[b.index]}" id="colSecondarySortDirection${b.index}" placeholder="Direction 5" style="width:65px">
        </li>
    </ul>
</div>
