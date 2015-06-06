<%@include file="tags.jsp"%>
<c:set var="biasingProfileCount" value="${model.biasingProfileCount}"/>
<c:set var="width" value="${100/biasingProfileCount}"/>
<div id="scratchArea" style="display: none;"></div>
<table style="margin-left:10px;"><tr>

<c:forEach begin="0" end="${biasingProfileCount -1}" varStatus="b">
<c:set var="name" value="results${b.index}"/>
<c:set var="results" value="${model[name]}"/>
<td class="recordColumn" style="padding-right:2px;" valign="top" width="width:${width}%">

<c:set var="index" value="${b.index}"/>
<%@include file="debug.jsp"%>
<input type="text" id="biasing${b.index}" value="${results.biasingProfile}" placeholder="Biasing Profile" style="width:120px;">
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
  </td>  </tr></table>
<script>

    $('.highlightCorresponding').mouseenter(function() {
        var matchingRecords = $(this).attr('data-id').substring(5);
        $('.' + matchingRecords).addClass('highlight');
    }).mouseleave(function(){
        $('.highlightCorresponding').removeClass('highlight');
    });

    $('.recordColumn input').keyup(function(e){
        var code = (e.keyCode ? e.keyCode : e.which);
        if (code == 13) {
            e.preventDefault();
            e.stopPropagation();
            saveForm();
            $('#form').submit();
        } else {
            var biasings = '';
            $('.recordColumn input').each(function(){
                biasings += $(this).val() +  ","
            });
            biasings = biasings.substring(0, biasings.length-1);
            $('#biasingProfile').val(biasings);
            $('#biasingProfile').trigger('change');
        }
    });

    function removeColumn(pIndex){
        $('#biasing' + pIndex).parent().hide('slide');
        $('#biasing' + pIndex).remove();
        $('.recordColumn input').trigger('keyup');
        saveForm();
        $('#form').submit();
    }
    function addColumn(pIndex){
        var oldValue = $('#biasingProfile').val();
        var newValue = oldValue + ',' + $('#biasing' + pIndex).val();
        $('#biasingProfile').val(newValue);
        $('#biasingProfile').trigger('change');
        saveForm();
        $('#form').submit();
    }
</script>