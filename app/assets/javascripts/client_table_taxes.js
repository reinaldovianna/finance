$(document).on('click', '.dropdown-menu .tax-option', function(event){
  $(".btn-default").text($(this).text());
});

$(document).on('click', '.open-tax-modal', function(event){
  $table_tax_list = $(this).parents('.table-tax-list');

  $table_tax_list.addClass("table-tax-list-modal-active");
});

$(document).on('click', '.table-tax-list .tax-global-option', function(event){
  event.preventDefault();

  selectGlobalTableTax($(this));
});

$(document).on('click', '.table-tax-list .tax-option', function(event){
  event.preventDefault();

  selectTableTax($(this));
});

$(document).on('mouseover', '.tax-option-group', function(event){
  $(this).children('.remove-client-table-tax').css('display', 'block');
});

$(document).on('mouseout', '.tax-option-group', function(event){
  $(this).children('.remove-client-table-tax').css('display', 'none');
});

$(document).on('click', '.remove-client-table-tax', function(event){
  event.preventDefault();

  removeClientTableTax($(this));
});

removeClientTableTax = function(element) {
  $remove_contact_path = element.attr('href');
  return $.get($remove_contact_path).done( function(data) {
    alert(data.responseText);
    return element.parents('.tax-option-group').remove();    
  }(this));
};

selectTableTax = function(element) {
  $table_uri = '/table_taxes/show_table_tax/';
  $table_id = element.data("table-tax-id");
  $table_path = $table_uri + $table_id;
  return $.get($table_path, function(data) {
    $(".table-tax-context").html(data.form);
    return $('.chosen-select').chosen({width: "100%"});
  });
};

selectGlobalTableTax = function(element) {
  $table_uri = '/table_taxes/clone_table_tax/';
  $table_id = element.data("table-tax-id");
  $table_path = $table_uri + $table_id;
  return $.get($table_path, function(data) {
    $(".table-tax-context").html(data.form);
    return $('.chosen-select').chosen({width: "100%"});
  });
};