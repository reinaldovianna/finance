$(document).on('click', '.add-table-tax-row', function(event){
  event.preventDefault();

  sendLine($(this));
});

$(document).on('click', '.remove-table-tax-row', function(event){
  event.preventDefault();

  removeLine($(this));
});

/* Rows */

sendLine = function(element) {

  if (validFieldsRulePresent(content_base(element, '.form-table-tax')) === true) {
    setAlert(content_base(element, '.form-table-tax'), '.table-tax-alert', 'danger', 'Todos os campos do registro devem estar preenchidos.');
    return false;
  }

  $data = parseJsonDataSendLine(content_base(element, '.form-table-tax'));

  $.ajax({
    type: 'POST',
    url: element.attr('href'),
    dataType: 'json',
    data: $data
  }).always(function(data) {
    responseSendLine(content_base(element, '.form-table-tax'), data);
  });
};

parseJsonDataSendLine = function(form_table_tax) {
  return {
          rows: {
            row_type: form_table_tax.find('.row-type').val(),
            row_name: form_table_tax.find('.row-name').val(),
            row_measurement: form_table_tax.find('.row-measurement').val(),
            row_value: form_table_tax.find('.row-value').val()
          },
          table: {
            id: form_table_tax.find(".table-tax-id").val()
          }
        };
};

validFieldsRulePresent = function(element) {
  return element.find(".row-type").val().trim() === "" || element.find(".row-name").val().trim() === "" || 
         element.find(".row-measurement").val().trim() === "" || element.find(".row-value").val().trim() === "";
};

responseSendLine = function(form_table_tax, data){  
  switch (data.statusText) {
    case 'OK':
      form_table_tax.find('.list-tax-rows').prepend(data.responseText);
      form_table_tax.find('.table-tax-row').first().fadeOut(150).fadeIn(150).fadeOut(150).fadeIn(150);
      form_table_tax.find('.input-row').val("");
      form_table_tax.find('.table-tax-alert').fadeOut();
      // form_table_tax.find('.chosen-drop .chosen-results').addClass('cuelho');
      // form_table_tax.find('.cuelho').remove();
      // form_table_tax.find('.cuelho').prepend(ruleOption('123', 'Teste'));
      break;
    case 'Conflict':
      setAlert(form_table_tax, '.table-tax-alert', 'info', 'O registro informado já se encontra na tabela.');
      break;
    case 'Internal Server Error':
      setAlert(form_table_tax, '.table-tax-alert', 'danger', 'Erro interno, entre em contato com o suporte técnico.');
      break;
    default:
      $message = data.statusText + " : " + data.responseText.substring(0, 400);
      setAlert(form_table_tax, '.table-tax-alert', 'danger', $message);
  };
};

responseRemoveLine = function(element, data){
  $row_current = element.parents('.table-tax-row');

  if (data.statusText === 'OK') {
    $($row_current).fadeOut('normal', function() {
      element.remove();
    });
    setAlert(content_base(element, '.form-table-tax'), '.table-tax-alert', 'success', 'Registro removido com sucesso.');
  } else {
    $message = "Não foi possível excluir o registro - " + data.responseText.substring(0, 400);
    setAlert(content_base(element, '.form-table-tax'), '.table-tax-alert', 'danger', $message);
  }  
};

removeLine = function(element) {

  $data = parseJsonDataRemoveLine(element);

  $.ajax({
    type: 'POST',
    url: element.attr('href'),
    dataType: 'json',
    data: $data
  }).always(function(data) {
    responseRemoveLine(element, data);
  });
};

parseJsonDataRemoveLine = function(element) {
  return {
          rows: {
            id: element.data('table-tax-row-id')
          },
          table: {
            id: content_base(element, '.form-table-tax').find(".table-tax-id").val()
          }
        };
};

ruleOption = function(id, name) {
  return '<li class="active-result" data-option-array-index="'+id+'">'+name+'</li>';
};