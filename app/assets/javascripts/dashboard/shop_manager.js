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
});
