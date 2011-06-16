// Place your application-specific JavaScript functions and classes here
$(document).ready(function() {
  $(".must-confirm").click(function(ev) {
    if (!confirm($(this).attr('message'))) {
      ev.preventDefault();
    }
  });
  
  $(".check-all").click(function() {
    if($(this).is(":checked")) {
      $('.checkable').attr('checked', 'checked');
    } else {
      $('.checkable').removeAttr('checked');
    }
  });
});
