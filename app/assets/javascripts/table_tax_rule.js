$(document).on('click', '.add-table-tax-rule', function(event){
  event.preventDefault();

  sendLineRule($(this));
});

$(document).on('click', '.remove-table-tax-rule', function(event){
  event.preventDefault();

  removeLineRule($(this));
});

/* Rules */

sendLineRule = function(element) {
  $form_table_tax = element.parents('.form-table-tax');
  
  if (validFieldsRowPresent($form_table_tax) === true) {
    setAlert(content_base(element, '.form-table-tax'), '.table-tax-rules-alert', 'danger', 'Todos os campos do registro devem estar preenchidos.');
    return false;
  }

  $data = parseJsonDataSendLineRule($form_table_tax);

  $.ajax({
    type: 'POST',
    url: element.attr('href'),
    dataType: 'json',
    data: $data
  }).always(function(data) {
    responseSendLineRule($form_table_tax, data);
  });
};

parseJsonDataSendLineRule = function(form_table_tax) {
  return {
          rules: {
            row_ids: form_table_tax.find(".rule-row-ids").val(),
            operator: form_table_tax.find(".rule-operator").val(),
            measurement: form_table_tax.find('.rule-measurement').val(),
            value: form_table_tax.find('.rule-value').val()
          },
          table: {
            id: form_table_tax.find(".table-tax-id").val()
          }
        };
};

validFieldsRowPresent = function(element) {
  return element.find(".rule-row-ids").val() === null || element.find(".rule-operator").val().trim() === "" || 
         element.find(".rule-measurement").val().trim() === "" || element.find(".rule-value").val().trim() === "";
};

responseSendLineRule = function(form_table_tax, data){
  $element_alert = form_table_tax.parent().children('.table-tax-rules-alert');

  switch (data.statusText) {
    case 'OK':
      form_table_tax.find('.list-tax-rules').prepend(data.responseText);
      $('.table-tax-rule').first().fadeOut(150).fadeIn(150).fadeOut(150).fadeIn(150);
      $(".input-rule").val("");
      form_table_tax.find('.table-tax-rules-alert').fadeOut();
      break;
    case 'Conflict':
      setAlert(content_base(element, '.form-table-tax'), '.table-tax-rules-alert', 'info', 'O registro informado já se encontra na tabela.');
      break;
    case 'Internal Server Error':
      setAlert(content_base(element, '.form-table-tax'), '.table-tax-rules-alert', 'danger', 'Erro interno, entre em contato com o suporte técnico.');
      break;
    default:
      $message = data.statusText + " : " + data.responseText.substring(0, 400);
      setAlert(content_base(element, '.form-table-tax'), '.table-tax-rules-alert', 'danger', $message);
  };
};

responseRemoveLineRule = function(element, data){
  $rule_current = element.parents('.table-tax-rule');

  if (data.statusText === 'OK') {
    $($rule_current).fadeOut('normal', function() {
      element.remove();
    });
    setAlert(content_base(element, '.form-table-tax'), '.table-tax-rules-alert', 'success', 'Registro removido com sucesso.');
  } else {
    $message = "Não foi possível excluir o registro - " + data.responseText.substring(0, 400);
    setAlert(content_base(element, '.form-table-tax'), '.table-tax-rules-alert', 'danger', $message);
  }  
};

removeLineRule = function(element) {
  $form_table_tax = element.parents('.form-table-tax');

  $data = parseJsonDataRemoveLineRule(element);

  $.ajax({
    type: 'POST',
    url: element.attr('href'),
    dataType: 'json',
    data: $data
  }).always(function(data) {
    responseRemoveLineRule(element, data);
  });
};

parseJsonDataRemoveLineRule = function(element) {
  return {
          rules: {
            id: element.data('table-tax-rule-id')
          },
          table: {
            id: $form_table_tax.find(".table-tax-id").val()
          }
        };
};