setAlert = function(element_base, alert_class, type, message) {
  element_alert = element_base.find(alert_class);
  $alertTypeClass = 'alert-' + type;
  element_alert.html("<div class='alert " + $alertTypeClass + "'>" + message + "</div>");
  return element_alert.fadeOut('fast').fadeIn(400);
};

content_base = function(element, base_class) {
  return element.parents('.form-table-tax');
};