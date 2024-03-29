<div class="header">
  <form id="cookieForm">
    <div class="info-bar">
      <div class="logo-area">
        <img src="/images/logo.svg" /><span>Reference App</span>
      </div>
      <div class="cac-area grow">
        <span>CUSTOMER: <b>${empty cookie.customerId.value ? 'not set' : cookie.customerId.value}</b></span>
        <span>AREA: <b>${empty cookie.area.value ? 'Production' : cookie.area.value}</b></span>
        <span>COLLECTION: <b><a>${empty cookie.collection.value ? 'default' : cookie.collection.value}</a></b></span>
      </div>
      <div>
        <a href="javascript:;" onclick="showForm()" class="settings__button btn icon">
          <svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" id="Layer_1" width="20px" height="20px" viewBox="0 0 512 512" enable-background="new 0 0 512 512" xml:space="preserve">
              <path d="M348,327.195v-35.741l-32.436-11.912c-2.825-10.911-6.615-21.215-12.216-30.687l0.325-0.042l15.438-32.153l-25.2-25.269  l-32.118,15.299l-0.031,0.045c-9.472-5.601-19.758-9.156-30.671-11.978L219.186,162h-35.739l-11.913,32.759  c-10.913,2.821-21.213,6.774-30.685,12.379l-0.048-0.248l-32.149-15.399l-25.269,25.219l15.299,32.124l0.05,0.039  c-5.605,9.471-11.159,19.764-13.98,30.675L50,291.454v35.741l34.753,11.913c2.821,10.915,7.774,21.211,13.38,30.685l0.249,0.045  l-15.147,32.147l25.343,25.274l32.188-15.298l0.065-0.046c9.474,5.597,19.782,10.826,30.695,13.652L183.447,460h35.739  l11.915-34.432c10.913-2.826,21.209-7.614,30.681-13.215l0.05-0.175l32.151,15.192l25.267-25.326l-15.299-32.182l-0.046-0.061  c5.601-9.473,8.835-19.776,11.66-30.688L348,327.195z M201.318,368.891c-32.897,0-59.566-26.662-59.566-59.565  c0-32.896,26.669-59.568,59.566-59.568c32.901,0,59.566,26.672,59.566,59.568C260.884,342.229,234.219,368.891,201.318,368.891z"/>
              <path d="M462.238,111.24l-7.815-18.866l-20.23,1.012c-3.873-5.146-8.385-9.644-13.417-13.42l0.038-0.043l1.06-20.318l-18.859-7.822  L389.385,66.89l-0.008,0.031c-6.229-0.883-12.619-0.933-18.988-0.025L356.76,51.774l-18.867,7.815l1.055,20.32  c-5.152,3.873-9.627,8.422-13.403,13.46l-0.038-0.021l-20.317-1.045l-7.799,18.853l15.103,13.616l0.038,0.021  c-0.731,5.835-1.035,12.658-0.133,19.038l-15.208,13.662l7.812,18.87l20.414-1.086c3.868,5.144,8.472,9.613,13.495,13.385  l0.013,0.025l-1.03,20.312l20.668,7.815L374,201.703v-0.033c4,0.731,10.818,0.935,17.193,0.04l12.729,15.114l18.42-7.813  l-1.286-20.324c5.144-3.875,9.521-8.424,13.297-13.456l-0.023,0.011l20.287,1.047l7.802-18.864l-15.121-13.624l-0.033-0.019  c0.877-6.222,0.852-12.58-0.05-18.953L462.238,111.24z M392.912,165.741c-17.359,7.19-37.27-1.053-44.462-18.421  c-7.196-17.364,1.047-37.272,18.415-44.465c17.371-7.192,37.274,1.053,44.471,18.417  C418.523,138.643,410.276,158.547,392.912,165.741z"/>
          </svg>
          <span>Settings</span>
        </a>

      </div>

    </div>
    <div class="settings-block" style="display:${cookie.showForm.value ? 'block' : 'none'}">
      <section class="settings-block__basic">
        <div class="row">
            <fieldset>
              <legend><span>Connection</span></legend>
              <input type="text" name="customerId" id="customerId" placeholder="Customer ID / Domain" class="input--small">
              <input type="text" name="clientKey" id="clientKey" placeholder="Client Key" class="input--medium"><br/>
              <span class="collection">
                <input type="text" name="collection" id="collection" placeholder="Collection" class="input--medium">
                <c:if test="${collectionCount > 0}">
                  <div class="collection__count">(${collectionCount})</div>
                </c:if>
              </span>
              <input type="text" name="area" id="area" placeholder="Area" class="input--medium">
            </fieldset>
            <fieldset>
              <legend><span>Customization</span></legend>
              <div class="column">
                <input type="text" name="fields" id="fields" placeholder="Field List, comma separated" class="input--large">
                <input title="Custom Parameters, name=value & separated" type="text" name="customUrlParameters" id="customUrlParameters" placeholder="Custom URL Parameters" class="input--large">
                <input type="text" name="visitorId" id="visitorId" placeholder="Personalized Relevance - Visitor ID" class="input--medium">
              </div>
            </fieldset>
        </div>
      </section>
      <a href="javascript:;" onclick="showAdvanced()" class="btn scnd advanced-btn">Advanced Settings</a>

      <section id="advanced" class="settings-block__advanced"  style="display:${cookie.showAdvanced.value ? 'block' : 'none'}">

        <div class="row">

          <fieldset>
            <legend><span>Navigation Control</span></legend>
            <div class="column">
              <input type="text" name="includedNavigations" id="includedNavigations" placeholder="Included Navigations" class="input--medium">
              <input type="text" name="excludedNavigations" id="excludedNavigations" placeholder="Excluded Navigations" class="input--medium">
              <input type="text" name="restrictNavigationName" id="restrictNavigationName" placeholder="Restrict by Navigation" class="input--medium">
              <input type="text" name="restrictNavigationCount" id="restrictNavigationCount" placeholder="Count" class="input--medium">
              <div class="checkbox-area">
                <label for="dontPruneRefinements"><input type="checkbox" name="dontPruneRefinements" id="dontPruneRefinements" checked="checked">Do not Prune Refinements</label>
              </div>

            </div>

          </fieldset>

          <fieldset>
            <legend><span>Result Display</span></legend>
            <div class="column">
              <div class="checkbox-area"><label for="raw"><input type="checkbox" name="raw" id="raw">Show Raw</label></div>
              <div class="checkbox-area"><label for="collapse"><input type="checkbox" name="collapse" id="collapse">Collapse JSON</label></div>
              <div class="fieldset__section-header">
                <label>Image Display</label>
              </div>
              <div class="row">
                <input title="Supports JQ syntax" type="text" name="imageField" id="imageField" placeholder="Image Attribute">
                <input type="text" name="imagePrefix" id="imagePrefix" placeholder="Image Prefix">
                <input type="text" name="imageSuffix" id="imageSuffix" placeholder="Image Suffix">
              </div>

            </div>
          </fieldset>

          <fieldset>
            <legend><span>Result Control</span></legend>
            <div class="column">
              <input type="text" name="sortField" id="sortField" placeholder="Sort Field">
              <input type="text" name="sortOrder" id="sortOrder" placeholder="Order A/D">
              <input type="text" name="bringToTop" id="bringToTop" placeholder="Bring To Top, comma separated list of Product IDs" class="input--large">
              <input type="text" name="language" id="language" placeholder="Language" class="input--small">
              <div class="checkbox-area">
                <label for="disableAutocorrection"><input type="checkbox" name="disableAutocorrection" id="disableAutocorrection">Disable Autocorrection</label>
              </div>
              <input type="hidden" name="biasingProfile" id="biasingProfile">
              <input type="hidden" name="matchStrategy" id="matchStrategy">
              <input type="hidden" name="skipSemantish" id="skipSemantish">
              <input type="hidden" name="wildcard" id="wildcard">
              <input type="hidden" name="sessionId" id="sessionId">
              <c:forEach begin="0" end="4" varStatus="i">
                <input type="hidden" name="colSort${i.count}" id="colSort${i.count}">
                <input type="hidden" name="colDir${i.count}" id="colDir${i.count}">
              </c:forEach>
            </div>
          </fieldset>
          <fieldset>
            <legend><span>Page Control</span></legend>
            <div class="row">

              <input type="text" name="pageSize" id="pageSize" placeholder="Page Size (max 120)" class="input--small">
              <div class="checkbox-area">
                <label title="If checked, the cache will be used.  This means changes to data and rules will not appear until the cache expires" for="cache"><input type="checkbox" name="cache" id="cache">Use Cache</label>
              </div>
            </div>
          </fieldset>
        </div>
      </section>
    </div>
  </form>
</div>
