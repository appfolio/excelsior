$(document).ready(function() {
  $(document).on('click', '.js-like', function(e) {
    e.stopImmediatePropagation();

    $.post( "/likes?message_id=" + $(e.target).data('message-id') + "&user_id=" + $(e.target).data('user-id'), function( data ) {
      $('#' + $(e.target).data('message-id') + '_like_count').html(data);
    });
    return false;
  });

  $(document).on('click', '.js-card-clickable', function() {
    window.open($(this).data('link'), '_blank');
  });
});
