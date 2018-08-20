(function() {
    $("#add-store").click(function(event) {
      event.preventDefault();
      event.stopPropagation();
      this.add_store_path = $(this).attr('href');
      return $.get(this.add_store_path, function(data) {
        return $("#content-stores").append("<div class='content-store'>"+data.form+'</div>');
      });
    });

}).call(this);

removeStore = function(element) {
  $remove_store_path = element.attr('href');
  return $.get($remove_store_path).done( function(data) {
    return element.parents('.content-store').remove();    
  }(this));
};

$(document).on('click', '.remove-store', function(event){
  event.preventDefault();

  removeStore($(this));
});

$(document).on('click', '#add-store', function(event){
	event.preventDefault();
	event.stopPropagation();
	$add_store_path = $(this).attr('href');
	$.get($add_store_path, function(data) {
		$("#content-stores").append("<div class='content-store'>"+data.form+'</div>');
	});
});