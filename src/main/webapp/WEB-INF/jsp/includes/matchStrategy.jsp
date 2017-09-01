<a href="javascript:;" onclick="showMatchStrategy()" class="btn scnd sml">View Match Strategy</a>
    <div style="display:${cookie.showMatchStrategy.value or !empty matchStrategyErrors[b.index] ? 'block' : 'none'}" class="matchStrategyHolder">
        <textarea style="width:250px;height:100px;font-size:10px;" id="strategy${b.index}" class="strategyInput" placeholder="Match Strategy"><c:out value="${URLDecoder.decode(matchStrategies[b.index], 'UTF-8')}"/></textarea>
        <br/>
        <a href="javascript:;" onclick="$('#strategy${b.index}').val($('#exampleMatchStrategy').text());$('.strategyInput, .biasingInput').trigger('change');" class="btn scnd sml">Insert example strategy</a>
        <div id="exampleMatchStrategy" style="display:none">{rules: [
        { terms: 2, mustMatch: 1 },
        { terms: 3, mustMatch: 2 },
        { terms: 4, mustMatch: 2 },
        { termsGreaterThan: 4, mustMatch: 50, percentage: true }
        ]}</div>
    </div>
