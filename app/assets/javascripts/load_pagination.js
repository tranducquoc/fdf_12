$(document).ready(function() {
  $('.load-more-products a').click(function(e) {
    e.preventDefault();
    $('.load-more-products a').html(I18n.t('load_more_products'));
    $.get(this.href, null, null, 'script');
  });
});
