$(document).ready(function() {
  $('.domain-member').on('shown.bs.modal', function() {
    var domain_id = this.dataset.domain;
    var data = {domain_id: domain_id};
    $.get('/user_domain_searches', data, null, 'script');
    return false;
  }); 
});

function search_domain_user(obj){
  var user_search = $(obj).val();
  var domain_id = obj.dataset.domain;
  var data = {user_search: user_search, domain_id: domain_id};
  $.get('/user_domain_searches', data, null, 'script');
  return false;
};
