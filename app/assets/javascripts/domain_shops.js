$(document).ready(function() {
  $('.domain-shop').on('shown.bs.modal', function() {
    var domain_id = this.dataset.domain;
    var data = {domain_id: domain_id};
    $.get('/shop_domains', data, null, 'script');
    return false;
  }); 
});
