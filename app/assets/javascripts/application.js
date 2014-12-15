//= require jquery
//= require jquery_ujs
//= require semantic-ui
//= require aaf-layout

jQuery(function($) {
  $('.popup').popup({ inline: true, position: 'right center' });

  $.fn.form.settings.rules['urlsafe_base64'] = function(value) {
    return value.match(/^[\w-]*$/);
  };

  $.fn.form.settings.rules['attribute_name'] = function(value) {
    return value == 'eduPersonEntitlement';
  };

  $.fn.form.settings.rules['attribute_value'] = function(value) {
    return value.match(/^urn:mace:aaf\.edu\.au:ide:([\w\.-]+:)*[\w\.-]+$/);
  };
});
