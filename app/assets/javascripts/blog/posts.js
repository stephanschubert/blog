// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {

  // TODO Works for one localization only.
  var toggleLocalization = function(field) {
    var input        = $("#post_" + field)
      , localization = $("#post_localizations_attributes_0_" + field + "_input")
    ;

    return function(ev) {
      var link = $(this);

      if(localization.is(":visible")) {
        link.text("Übersetzen");
        localization.hide();
      } else {
        link.text("Übersetzung ausblenden");
        localization.insertAfter(input).show();
      }
    };
  };

  $(".localizations").hide();

  $(['title', 'body']).each(function(i, field) {
    $("<a>")
      .attr({
        href: "#localize"
      })
      .text("Übersetzen")
      .click(toggleLocalization(field))
      .appendTo($("#post_" + field + "_input label"));
  });

});