$(document).ready(function() {
  $(document).on('click', '.js-card-clickable', function() {
    window.open($(this).data('link'), '_blank');
  });
});
