(function() {
  $(document).on('ready page:load', function() {
    $("#add-client-contact").click(function(event) {
      event.preventDefault();
      event.stopPropagation();
      this.add_contact_path = $(this).attr('href');
      return $.get(this.add_contact_path, function(data) {
        return $("#content-client-contacts").append(data.form);
      });
    });
  });

}).call(this);

removeContact = function(element) {
  $remove_contact_path = element.attr('href');
  return $.get($remove_contact_path).done( function(data) {
    return element.parents('.content-client-contact').remove();    
  }(this));
};

$(document).on('click', '.remove-contact', function(event){
  event.preventDefault();

  removeContact($(this));
});
