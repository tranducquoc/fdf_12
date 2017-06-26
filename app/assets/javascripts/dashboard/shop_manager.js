$(document).ready(function() {
  $('#new-manager-search').hsearchbox({
    url: '/dashboard/new_manager_searches/',
    param: 'search',
    dom_id: '#new-manager-dom',
    loading_css: '#livesearch_loading'
  });

  $(document).on('click', '.manager-search', function() {
    $('#new-manager-search').val(this.dataset.email);
  });

  $('#manager_of_shop').on('shown.bs.modal', function() {
    get_list_user()
  });

  $('#filter-user-by-shop-domain').on('change', function(){
    get_list_user()
  });

  $('#user_by_shop_domain').on('keyup',function() {
    get_list_user()
  });
});

function get_list_user() {
  var domain_id = $('#filter-user-by-shop-domain').val();
  var shop_id = $('#shop_id').val();
  var user_search = $('#user_by_shop_domain').val();
  var data = {domain_id: domain_id, shop_id: shop_id, user_search :user_search};
  $.get('/dashboard/shop_manager_domains', data, null, 'script');
  return false;
};
