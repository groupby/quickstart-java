<%@include file="tags.jsp"%>
<c:set var="biasingProfileCount" value="${model.biasingProfileCount}"/>
<c:set var="width" value="${100/biasingProfileCount}"/>
<div id="scratchArea" style="display: none;"></div>
<table width="100%">
    <tr>

    <c:forEach begin="0" end="${biasingProfileCount -1}" varStatus="b">
    <c:set var="name" value="results${b.index}"/>
    <c:set var="results" value="${model[name]}"/>
    <td class="recordColumn" style="padding-right:2px;" valign="top" width="width:${width}%">

    <c:set var="index" value="${b.index}"/>
    <%@include file="debug.jsp"%>
    <input type="text" id="biasing${b.index}" class="biasingInput" value="${results.biasingProfile}" placeholder="Biasing Profile" style="width:220px;">
    <br>
    <a href="javascript:;" onclick="showMatchStrategy()">Match Strategy</a>
    <div style="display:${cookie.showMatchStrategy.value ? 'block' : 'none'}" class="matchStrategyHolder">
    <textarea style="width:400px;height:200px;font-size:10px;" id="strategy${b.index}" class="strategyInput" placeholder"Match Strategy"><c:out value="${URLDecoder.decode(matchStrategies[b.index], 'UTF-8')}"/></textarea>
    </div>
    ${matchStrategyErrors[b.index]}
    <c:if test="${b.index > 0}">
    <a href="javascript:;" onclick="removeColumn(${b.index});">-</a>
    </c:if>
    <a href="javascript:;" onclick="addColumn(${b.index})">+</a>


    <ol id="replacementRow${b.index}" style="display: none">

    </ol>


    <ol id="row${b.index}">
    <%@include file="record.jsp"%>
    </ol>

    </c:forEach>
    </td>
    </tr>
</table>
<script>

    $('.highlightCorresponding').mouseenter(function() {
        var matchingRecords = $(this).attr('data-id').substring(5);
        $('.' + matchingRecords).addClass('highlight');
    }).mouseleave(function(){
        $('.highlightCorresponding').removeClass('highlight');
    });

    $('.strategyInput, .biasingInput').keyup(function(e){
        var code = (e.keyCode ? e.keyCode : e.which);
        var strategy = '';
        $('.strategyInput').each(function(){
            strategy += $(this).val() +  "|"
        });
        strategy = strategy.substring(0, strategy.length-1);
        $('#matchStrategy').val(strategy);
        $('#matchStrategy').trigger('change');

        var biasings = '';
        $('.biasingInput').each(function(){
            biasings += $(this).val() +  ","
        });
        biasings = biasings.substring(0, biasings.length-1);
        $('#biasingProfile').val(biasings);
        $('#biasingProfile').trigger('change');
        saveForm();
    });

    function removeColumn(pIndex){
        $('#biasing' + pIndex).parent().hide('slide');
        $('#biasing' + pIndex).remove();
        $('#strategy' + pIndex).remove();
        $('.strategyInput, .biasingInput').trigger('keyup');
        saveForm();
        $('#form').submit();
    }
    function addColumn(pIndex){
        var oldValue = $('#biasingProfile').val();
        var newValue = oldValue + ',' + $('#biasing' + pIndex).val();
        $('#biasingProfile').val(newValue);
        $('#biasingProfile').trigger('change');

        var oldValue = $('#matchStrategy').val();
        var newValue = oldValue + '|' + $('#strategy' + pIndex).val();
        $('#matchStrategy').val(newValue);
        $('#matchStrategy').trigger('change');

        saveForm();
        $('#form').submit();
    }
</script>