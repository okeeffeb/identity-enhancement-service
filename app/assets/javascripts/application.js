//= require jquery
//= require jquery_ujs
//= require semantic-ui
//= require aaf-layout

jQuery(function($) {
  $.fn.form.settings.rules['urlsafe_base64'] = function(value) {
    return value.match(/^[\w-]*$/);
  };
});
