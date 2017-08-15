

<%@include file="tags.jsp" %>

<c:set var="biasingProfileCount" value="${model.biasingProfileCount}"/>

<fmt:formatNumber var="formattedWidth" type="number" minFractionDigits="0" maxFractionDigits="0" value="${100/biasingProfileCount}" />
<c:set var="width" value="${formattedWidth}" />

<div id="scratchArea" style="display: none;"></div>
<div class="row">
  <c:forEach begin="0" end="${biasingProfileCount -1}" varStatus="b">
    <c:set var="name" value="error${b.index}"/>
    <c:set var="error" value="${model[name]}"/>
    <c:set var="name" value="results${b.index}"/>
    <c:set var="results" value="${model[name]}"/>
    <div class="recordColumn recordColumn${b.index} _${width}">
      <c:set var="index" value="${b.index}"/>
      <%--Only show error/warning box if there are some--%>
        <c:if test="${!empty matchStrategyErrors[b.index] or !empty results.warnings or (!empty error or !empty results.errors)}">

          <c:if test="${!empty matchStrategyErrors[b.index]}">
            <div class="error">
              <pre>${matchStrategyErrors[b.index]}</pre>
            </div>
          </c:if>
          <c:if test="${!empty results.warnings}">
            <div class="warnings">
              <c:forEach items="${results.warnings}" var="warning">
                <pre>Warning: ${warning}</pre>
              </c:forEach>
            </div>
          </c:if>
          <c:if test="${!empty error or !empty results.errors}">
            <div class="error">
              <pre style="white-space:normal">
              ${error}
              ${results.errors}
              </pre>
            </div>
          </c:if>

        </c:if>
      <div class="columnSpecifics" style="display:${cookie.showColumnSpecifics.value ? 'block' : 'none'}">
        <div class="row">
          <%@include file="debug.jsp" %>

          <fieldset>
            <legend><span>Relevance &amp; Recall</span></legend>
            <input type="text" id="biasing${b.index}" class="biasingInput" value="${results.biasingProfile}" placeholder="Biasing Profile" style="width:220px;">
            <br>
            <%@include file="matchStrategy.jsp" %>
            <%@include file="sort.jsp" %>
            <%@include file="semantish.jsp" %>
            <%@include file="wildcard.jsp" %>
            <div class="fieldset__section-header">
                <label>Personalized Relevance</label>
            </div>
            <%@include file="sessionId.jsp" %>
          </fieldset>
          <div class="columnControls">

            <a href="javascript:;" onclick="addColumn(${b.index})" class="btn scnd icon-only" title="Copy Set">
              <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" width="24px" height="24px"  viewBox="0 0 1000 1000" enable-background="new 0 0 1000 1000" xml:space="preserve">
                <g><path d="M255,990c-40.8,0-40.8-40.8-40.8-40.8V173.3c0,0,0-40.8,40.8-40.8h612.5c40.8,0,40.8,40.8,40.8,40.8v530.8L622.5,990H255L255,990z M255,949.2h367.5l245-245V173.3H255V949.2L255,949.2z M618.4,983.9c-1.6,0-3.2-0.3-4.7-0.9c-4.6-1.9-32.1-28.8-32.1-33.8v-245c0,0,0-40.8,40.8-40.8h285.8c0,0-29.2,29.1-32.7,32.7L627,980.3C624.7,982.7,621.6,983.9,618.4,983.9L618.4,983.9z M622.5,704.2v245l245-245H622.5z M785.8,336.7H336.7v-40.8h449.2V336.7z M785.8,459.2H336.7v-40.8h449.2V459.2z M785.8,581.7H336.7v-40.8h449.2V581.7z M173.3,785.8h-40.8v-735h571.7v40.8H745V50.8c0,0,0-40.8-40.8-40.8H132.5c-40.8,0-40.8,40.8-40.8,40.8v735c0,0,0,40.8,40.8,40.8h40.8V785.8L173.3,785.8z"/></g>
              </svg>
            </a>
            <c:if test="${b.index > 0}">
              <a href="javascript:;" onclick="removeColumn(${b.index});" class="btn scnd del" title="Delete Set">
                <svg
                  xmlns:dc="http://purl.org/dc/elements/1.1/"
                  xmlns:cc="http://creativecommons.org/ns#"
                  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                  xmlns:svg="http://www.w3.org/2000/svg"
                  xmlns="http://www.w3.org/2000/svg"
                  xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
                  xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
                  viewBox="0 -256 1792 1792"
                  id="svg3741"
                  version="1.1"
                  inkscape:version="0.48.3.1 r9886"
                  width="25px" height="25px"
                  sodipodi:docname="trash_font_awesome.svg">

                  <g
                    transform="matrix(1,0,0,-1,197.42373,1255.0508)"
                    id="g3743">
                    <path
                      d="M 512,800 V 224 q 0,-14 -9,-23 -9,-9 -23,-9 h -64 q -14,0 -23,9 -9,9 -9,23 v 576 q 0,14 9,23 9,9 23,9 h 64 q 14,0 23,-9 9,-9 9,-23 z m 256,0 V 224 q 0,-14 -9,-23 -9,-9 -23,-9 h -64 q -14,0 -23,9 -9,9 -9,23 v 576 q 0,14 9,23 9,9 23,9 h 64 q 14,0 23,-9 9,-9 9,-23 z m 256,0 V 224 q 0,-14 -9,-23 -9,-9 -23,-9 h -64 q -14,0 -23,9 -9,9 -9,23 v 576 q 0,14 9,23 9,9 23,9 h 64 q 14,0 23,-9 9,-9 9,-23 z M 1152,76 v 948 H 256 V 76 Q 256,54 263,35.5 270,17 277.5,8.5 285,0 288,0 h 832 q 3,0 10.5,8.5 7.5,8.5 14.5,27 7,18.5 7,40.5 z M 480,1152 h 448 l -48,117 q -7,9 -17,11 H 546 q -10,-2 -17,-11 z m 928,-32 v -64 q 0,-14 -9,-23 -9,-9 -23,-9 h -96 V 76 q 0,-83 -47,-143.5 -47,-60.5 -113,-60.5 H 288 q -66,0 -113,58.5 Q 128,-11 128,72 v 952 H 32 q -14,0 -23,9 -9,9 -9,23 v 64 q 0,14 9,23 9,9 23,9 h 309 l 70,167 q 15,37 54,63 39,26 79,26 h 320 q 40,0 79,-26 39,-26 54,-63 l 70,-167 h 309 q 14,0 23,-9 9,-9 9,-23 z"
                      id="path3745"
                      inkscape:connector-curvature="0"
                      style="fill:currentColor" />
                  </g>
                </svg>
              </a>
            </c:if>
          </div>
        </div>


      </div>

        <ol id="replacementRow${b.index}" class="" style="display: none">
        </ol>


        <ol id="row${b.index}" class="record-list">
          <%@include file="record.jsp" %>
        </ol>


    </div>
  </c:forEach>
</div>
<script>

  $('.highlightCorresponding').hover(function () {
    var matchingRecords = $(this).attr('data-id').substring(5);
    $('.' + matchingRecords).addClass('highlight');
  }, function () {
    $('.highlightCorresponding').removeClass('highlight');
  });

  $('.strategyInput, .biasingInput, .sortInput, .sortDir, .sessionIdInput').keyup(function (e) {
    var code = (e.keyCode ? e.keyCode : e.which);

    if (code == 13 && !$(this).hasClass('strategyInput')) {
      $('#form').submit();
      return;
    }
  });
  $('.sortInput, .sortDir').change(function (e) {
    for (var i = 1; i < 6; i++) {
      var sort = '';
      $('.sort' + i + 'Input').each(function () {
        sort += $(this).val() + "|"
      });
      sort = sort.substring(0, sort.length - 1);
      $('#colSort' + i).val(sort);

      var sort = '';
      $('.sort' + i + 'Dir').each(function () {
        sort += $(this).val() + "|"
      });
      sort = sort.substring(0, sort.length - 1);
      $('#colDir' + i).val(sort);
    }
    for (var i = 1; i < 6; i++) {
      $('#colSort' + i).trigger('change');
      $('#colDir' + i).trigger('change');
    }
  });

  $('.strategyInput').change(function (e) {
    var strategy = '';
    $('.strategyInput').each(function () {
      strategy += $(this).val() + "|"
    });
    strategy = strategy.substring(0, strategy.length - 1);
    $('#matchStrategy').val(strategy);
    $('#matchStrategy').trigger('change');
  });

  $('.sessionIdInput').change(function (e) {
    var sessionId = '';
    $('.sessionIdInput').each(function () {
      sessionId += $(this).val() + "|"
    });
    sessionId = sessionId.substring(0, sessionId.length - 1);
    $('#sessionId').val(sessionId);
    $('#sessionId').trigger('change');
  });

  $('.skipSemantishInput').change(function () {
    var skipSemantishes = '';
    $('.skipSemantishInput').each(function () {
      skipSemantishes += $(this).is(':checked') + ","
    });
    skipSemantishes = skipSemantishes.substring(0, skipSemantishes.length - 1);
    $('#skipSemantish').val(skipSemantishes);
    $('#skipSemantish').trigger('change');
  });

  $('.wildcardInput').change(function () {
    var wildcards = '';
    $('.wildcardInput').each(function () {
      wildcards += $(this).is(':checked') + ","
    });
    wildcards = wildcards.substring(0, wildcards.length - 1);
    $('#wildcard').val(wildcards);
    $('#wildcard').trigger('change');
  });

  $('.biasingInput').change(function (e) {
    var biasings = '';
    $('.biasingInput').each(function () {
      biasings += $(this).val() + ","
    });
    biasings = biasings.substring(0, biasings.length - 1);
    $('#biasingProfile').val(biasings);
    $('#biasingProfile').trigger('change');
  });

  function removeColumn(pIndex) {
    $('#biasing' + pIndex).remove();
    $('#matchStrategy' + pIndex).remove();
    $('.strategyInput, .biasingInput, .sortInput').trigger('change');
    generateHash();
    $('#form').submit();
  }
  function addColumn(pIndex) {
    var oldValue = $('#biasingProfile').val();
    var newValue = oldValue + ',' + $('#biasing' + pIndex).val();
    $('#biasingProfile').val(newValue);
    $('#biasingProfile').trigger('change');

    var oldValue = $('#matchStrategy').val();
    var newValue = oldValue + '|' + $('#strategy' + pIndex).val();
    $('#matchStrategy').val(newValue);
    $('#matchStrategy').trigger('change');

    generateHash();
    $('#form').submit();
  }
</script>
