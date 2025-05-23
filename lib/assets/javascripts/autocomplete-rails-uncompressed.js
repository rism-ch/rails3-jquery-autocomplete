/*
* Unobtrusive autocomplete
*
* To use it, you just have to include the HTML attribute autocomplete
* with the autocomplete URL as the value
*
*   Example:
*       <input type="text" data-autocomplete="/url/to/autocomplete">
*
* Optionally, you can use a jQuery selector to specify a field that can
* be updated with the element id whenever you find a matching value
*
*   Example:
*       <input type="text" data-autocomplete="/url/to/autocomplete" data-id-element="#id_field">
* RZ FIXME
* not really a fixme but a note:
* to recompile:
* rake uglify
* 01-2018: Updated for Jquery ui 1.12
*/

(function(jQuery)
{
  var self = null;
  jQuery.fn.railsAutocomplete = function() {
    var handler = function() {
      if (!this.railsAutoCompleter) {
        this.railsAutoCompleter = new jQuery.railsAutocomplete(this);
      }
    };

    return jQuery(document).on('focus','input[data-autocomplete]',handler);
  };

  jQuery.railsAutocomplete = function (e) {
    _e = e;
    this.init(_e);
  };

  jQuery.railsAutocomplete.fn = jQuery.railsAutocomplete.prototype = {
    railsAutocomplete: '0.0.2'
  };

  jQuery.railsAutocomplete.fn.extend = jQuery.railsAutocomplete.extend = jQuery.extend;
  jQuery.railsAutocomplete.fn.extend({
    init: function(e) {
      e.delimiter = jQuery(e).attr('data-delimiter') || null;
      e.min_length = jQuery(e).attr('min-length') || 2;
      e.append_to = jQuery(e).attr('data-append-to') || null;
      e.autoFocus = jQuery(e).attr('data-auto-focus') || false;
      function split( val ) {
        return val.split( e.delimiter );
      }
      function extractLast( term ) {
        return split( term ).pop().replace(/^\s+/,"");
      }

      jQuery(e).autocomplete({
        delay: 100,
        appendTo: e.append_to,
        autoFocus: e.autoFocus,
        source: function( request, response ) {
          params = {term: extractLast( request.term )}
          if (jQuery(e).attr('data-autocomplete-fields')) {
              jQuery.each(jQuery.parseJSON(jQuery(e).attr('data-autocomplete-fields')), function(field, selector) {
              params[field] = jQuery(selector).val();
            });
          }
          jQuery.getJSON( jQuery(e).attr('data-autocomplete'), params, function() {
            //if(arguments[0].length == 0) {
            //  arguments[0] = []
            //  arguments[0][0] = { id: "", label: "no existing match" }
            //}
            jQuery(arguments[0]).each(function(i, el) {
              var obj = {};
              obj[el.id] = el;
              jQuery(e).data(obj);
            });
            response.apply(null, arguments);
          });
        },
        change: function( event, ui ) {
            if(!jQuery(this).is('[data-id-element]') ||
                    jQuery(jQuery(this).attr('data-id-element')).val() == "") {
        	  	return;
        	  }
            jQuery(jQuery(this).attr('data-id-element')).val(ui.item ? ui.item.id : "");

            if (jQuery(this).attr('data-update-elements')) {
                var update_elements = jQuery.parseJSON(jQuery(this).attr("data-update-elements"));
                var data = ui.item ? jQuery(this).data(ui.item.id.toString()) : {};
                if(update_elements && jQuery(update_elements['id']).val() == "") {
                	return;
                }
                for (var key in update_elements) {
                    element = jQuery(update_elements[key]);
                    if (element.is(':checkbox')) {
                        if (data[key] != null) {
                            element.prop('checked', data[key]);
                        }
                    } else {
                        element.val(ui.item ? data[key] : "");
                    }
                }
            }
        },
        search: function() {
          // custom minLength
          var term = extractLast( this.value );
          if ( term.length < e.min_length ) {
            return false;
          }
        },
        focus: function() {
          // prevent value inserted on focus
          return false;
        },
        select: function( event, ui ) {
          var terms = split( this.value );
          // remove the current input
          terms.pop();
          // add the selected item
          terms.push( ui.item.value );
          // add placeholder to get the comma-and-space at the end
          if (e.delimiter != null) {
            terms.push( "" );
            this.value = terms.join( e.delimiter );
          } else {
            this.value = terms.join("");
            if (jQuery(this).attr('data-id-element')) {
              jQuery(jQuery(this).attr('data-id-element')).val(ui.item.id);
            }
            if (jQuery(this).attr('data-update-elements')) {
              var data = jQuery(this).data(ui.item.id.toString());
              var update_elements = jQuery.parseJSON(jQuery(this).attr("data-update-elements"));
              for (var key in update_elements) {
                  element = jQuery(update_elements[key]);
                  if (element.is(':checkbox')) {
                      if (data[key] != null) {
                          element.prop('checked', data[key]);
                      }
                  } else {
                      element.val(data[key]);
                  }
              }
            }
          }
          var remember_string = this.value;
          jQuery(this).on('keyup.clearId', function(){
            if(jQuery.trim(jQuery(this).val()) != jQuery.trim(remember_string)){
              jQuery(jQuery(this).attr('data-id-element')).val("");
              jQuery(this).off('keyup.clearId');
            }
          });
          jQuery(e).trigger('railsAutocomplete.select', ui);
          return false;
        }
      });
    }
  });

  function removeDiacritics(str) {
    return str.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
  }

  function highlightMatch(label, keyword) {
    const normalizedLabel = removeDiacritics(label.toLowerCase());
    const normalizedKeyword = removeDiacritics(keyword.toLowerCase());

    const index = normalizedLabel.indexOf(normalizedKeyword);    
    if (index === -1) return label; // no match

    const start = label.slice(0, index);
    const match = label.slice(index, index + keyword.length);
    const end = label.slice(index + keyword.length);

    return `${start}<strong>${match}</strong>${end}`;
  }

  jQuery(document).ready(function(){
    // Add highlighting to autocomplete
    // Updated for 1.12
    $.ui.autocomplete.prototype._renderItem = function (ul, item) {
      /* RZ: Old way
      // Escape any regex syntax inside this.term
      var cleanTerm = this.term.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');

      // Build pipe separated string of terms to highlight
      var keywords = $.trim(cleanTerm).replace('  ', ' ').split(' ').join('|');

      // Get the new label text to use with matched terms wrapped
      // in a span tag with a class to do the highlighting
      var re = new RegExp("(" + keywords + ")", "gi");
      var output = item.label.replace(re, '<strong>$1</strong>');
      */
      
      // RZ: New way
      var output = highlightMatch(item.label, this.term);
      
      // The div element is added in 1.12
      
      return $( "<li>" )
      .append( $( "<div>" ).append(output))
      .appendTo( ul );
    };
    
    jQuery('input[data-autocomplete]').railsAutocomplete();
  });
})(jQuery);
