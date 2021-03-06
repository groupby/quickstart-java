$(document).ready(function () {
    setInterval(redoQuery, 1000);
    prettyJson();

    // Add event listeners to 'records'.
    $( '.record' ).click( function( e ) {
      let attrs = getAttrs( e.target ) || [];

      // Filter, sanitize, and format 'attrs' data.
      var attrsStr = attrs
        .filter( ( str ) => ( !!str ) )
        .filter( ( str, i, arr ) => ( arr.indexOf( str ) === i ) )
        .map( ( str ) => ( str.replace( /[:;'"]/gmi, '' ) ) )
        .join( '.' );

      if ( attrsStr ) {
        window.addAnyNav( null, attrsStr + '=' );
      }
    } );

    if (!$('#raw').prop('checked')) {
        $('.jsonValue').each(function(index, value){
          try {
            $(this).JSONView(JSON.parse($(this).text()), { collapsed: $('#collapse').prop('checked')});
            $(this).show();
          } catch (e) {
            console.log(e);
          }
        });
    }
   $( "#collection" ).autocomplete({
      source: ${Mappers.writeValueAsString(collections)},
      delay: 20,
      minLength: 0
    });
    if (${biasingProfileCount} > 1) {
      $('.highlightCorresponding').each(function(index, value){
        var text = '| ';
        for (var i = 0; i < ${biasingProfileCount}; i++) {
          var matchingRecords = $(this).attr('data-id').substring(5);
          var matchingRow = $('.recordColumn' + i + ' .' + matchingRecords);
          if (matchingRow.length) {
            text += $('.record-title', matchingRow).attr('data-id') + '&nbsp;|&nbsp;';
          } else {
            text += '&nbsp;&nbsp;|&nbsp;';
          }
          $('.otherColumns',this).html(text);
        }
      });
    }
});

/**
 * Given a DOM node, validate it and extract an array of 'attrs' data.
 *
 * @param {HTMLElement} node
 * @return {Array}
 */
function getAttrs( node ) {
  // Validate args.
  if (
    !node
    || !node.parentNode
  ) {
    return;
  }

  // If the target IS NOT a key or prop, exit early.
  if (
    !node.classList.contains( 'prop' )
    && !node.classList.contains( 'key' )
  ) {
    return;
  }

  return walkJson( node.parentNode );
}

/**
 * Extract `attr` data from a given DOM node and recurse.
 *
 *
 * @param {HTMLElement} node
 * @param {Array<string>} acc
 * @return {Array}
 */
function walkJson( node, acc ) {
  acc = ( !!acc && Array.isArray( acc ) ) ? acc : [];

  // Top of the DOM? Return accumulated attrs.
  if ( !node || !node.tagName ) {
    return acc;
  }

  // If current node is a list item, attempt to extract prop data from children.
  if (
    node.tagName.toLowerCase() === 'li'
  ) {
    var el = $( node ).children( '.prop' );
    acc.unshift( ( el.get( 0 ) || {} ).innerText );
  }

  // If the current node is a top-level key/value, attempt to extract key data.
  if (
    node.classList.contains( 'keyValue' )
  ) {
    var el = $( node ).children( '.key' );
    acc.unshift( ( el.get( 0 ) || {} ).innerText );
  }

  return walkJson( node.parentNode, acc );
}

function addAnyNav( message, value ) {
  var defaults = {
    message: "Enter a new refinement to add",
    value: "attribute=value or range:20..50"
  };

  message = ( typeof message === 'string' ) ? message : defaults.message;
  value = ( typeof value === 'string' ) ? value : defaults.value;

  var newNav = window.prompt( message, value );
  if (newNav != null) {
    var refinements=$('#refinements').val();
    $('#refinements').val(refinements + '~' + newNav);
    $('#form').submit();
  }
}

function redoQuery() {
    if ($.cookie('reload') == 'true') {
        $.cookie('reload', 'false');
    } else {
        return;
    }
    var sForm = $('#form').serialize();
    $.ajax({
        type: 'post',
        url: 'index.html',
        data: $('#form').serialize() + '&action=getOrderList',
        dataType: 'json'
    }).done(function (pResponse) {
        $('#scratchArea').html(pResponse);
        $('.replacementRow').each(function () {
            var row = $(this).attr('data-count');
            $('#row' + row).quicksand($('#replacementRow' + row + ' li'))
        });
    });
}

function getMoreNav(navigationName) {
    $.post('moreRefinements.html', {
        'navigationName' : navigationName,
        'originalQuery' : $('#originalQuery').text()
    }).done(function(data){
        if (data != '' || data != undefined) {
            var navElement = document.getElementById("nav-"+navigationName);
            $(navElement).html(data);
            $(navElement).find('.facet-holder').css('max-height', '50vh');
        } else {
            console.log('No data received.');
        }
    });
}


function prettyJson() {
    $('.reformatJson').each(function (index, element) {
        try {
            var e = $(element);
            e.html(e.html()
                    .replace(/\[\{/g, '[<br/>{')
                    .replace(/},/g, '},<br/>')
                    .replace(/}]/g, '}<br/>]')
            );
        } catch (exception) {
            console.log('parse exception: ', exception);
        }
    });
}

var currentHash = location.hash;
if (currentHash){
    var hashes = currentHash.substring(1).split('&');
    hashes.forEach(function(pItem){
        var keyValue = pItem.split('=');
        if (keyValue && keyValue.length == 2 && keyValue[0] && keyValue[1] && keyValue[1] !== 'undefined') {
            $('#' + keyValue[0]).attr('value', decodeURIComponent(keyValue[1]));
            $.cookie(keyValue[0], decodeURIComponent(keyValue[1]));
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
    $('#cookieForm input').each(function(){
        var myId = $(this).attr('id');
        var type = $(this).attr('type');
        if ($.cookie(myId)) {
            if (type === 'checkbox'){
              $(this).prop("checked", $.cookie(myId) === 'true');
            } else {
                $(this).val($.cookie(myId));
            }
        }
    });
    generateHash();
}
function generateHash() {
    var hashLocation = '';
    $('#cookieForm input').each(function(){
        var myId = $(this).attr('id');
        if ($.cookie(myId)) {
            hashLocation += myId + '=' + escape($.cookie($(this).attr('id'))) + '&';
        }
    });
    location.hash = hashLocation;
}
saveForm();
$('#cookieForm input').bind('keyup blur click change', function(){
    var type = $(this).attr('type');
    if (type === 'checkbox') {
        $.cookie($(this).attr('id'), $(this).prop('checked'));
    } else {
        $.cookie($(this).attr('id'), $(this).val());
    }
    generateHash();
});

$('#form').submit(function(e){
    saveForm();
});

// Below are all the show/hide functions

function showForm(){
    $('.settings-block').slideToggle( function() {
        $.cookie('showForm', $('.settings-block').is(":visible"));
    });
}
function showAdvanced(){
    $('#advanced').slideToggle(function() {
        $.cookie('showAdvanced', $('#advanced').is(":visible"));
    });
}
function showZones(){
    $('#allZones').slideToggle( function() {
        $.cookie('showZones', $('#allZones').is(":visible"));
    });
}
function showColumnSpecifics(){
    $('.columnSpecifics').slideToggle(function() {
        $.cookie('showColumnSpecifics', $('.columnSpecifics').is(":visible"));
    });
}

function showRawQuery(){
    $('.raw-query-area').slideToggle( function() {
        $.cookie('showRawQuery', $('.raw-query-area').is(":visible"));
    });
}
function showJsonResponse(){
    $('.json-response-area').slideToggle( function() {
        $.cookie('showJsonResponse', $('.json-response-area').is(":visible"));
    });
}
function showMatchStrategy(){
    $('.matchStrategyHolder').slideToggle( function() {
        $.cookie('showMatchStrategy', $('.matchStrategyHolder').is(":visible"));
    });
}
function showSort(){
    $('.sortHolder').slideToggle( function() {
        $.cookie('showSort', $('.sortHolder').is(":visible"));
    });
}
function mobileShowNav(){
  $('.navigation').slideToggle( function() {
      $('.mobile-nav-button').toggleClass('mobile-nav-switch');
      $.cookie('mobileShowNav', $('.navigation').is(":visible"));
  });
    // $('.navigation').animate({left: "+=250"}, 500, function(){
    //     $.cookie('mobileShowNav', $('.navigation').is(":visible"));
    // });
}

function copyContent(copyMe){
  var copyArea = '.' + copyMe;

    $(copyArea).focus();
    $(copyArea).select();
    document.execCommand('copy');
    // $(copyArea).text('Copied to clipboard').show().fadeOut(1200);

}

new Clipboard('.copy');
