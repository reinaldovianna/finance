removeChannelStore = function(element) {
  $remove_channel_store_path = element.attr('href');
  return $.get($remove_channel_store_path).done( function(data) {
    return element.parents('.content-channel-store').remove();    
  }(this));
};

$(document).on('click', '.remove-channel-store', function(event){
  event.preventDefault();

  removeChannelStore($(this));
});

$(document).on('click', '.link-cnpj', function(event){
	$channel_element_id = $(this).data('object-id');
	$field_cnpj_id = '#channel_stores_' + $channel_element_id + '_cnpj_id';
	$field_cnpj_vat_number = '#vat_number_cnpj-channel-' + $channel_element_id;
	$($field_cnpj_id).addClass("id_cnpj-modal-active");
	$($field_cnpj_vat_number).addClass("vat_number_cnpj-modal-active");
});

$(document).on('click', '#add-channel-store', function(event){
	event.preventDefault();
	event.stopPropagation();
	$add_channel_store_path = $(this).attr('href');
	$.get($add_channel_store_path, function(data) {
		$("#content-channel-stores").append("<div class='content-channel-store'>"+data.form+"</div>");
	});
});