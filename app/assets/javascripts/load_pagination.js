$(document).ready(function() {
  $(document).on('click', '.load-more-products a', function(e) {
    e.preventDefault();
    $('.load-more-products a').html(I18n.t('load_more_products'));
    $.get(this.href, null, null, 'script');
  });
});
