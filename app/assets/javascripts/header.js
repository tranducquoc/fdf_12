$(document).on("ready page:load", $(function () {
  $('.dropdown-toggle').dropdown();
  $('#live-search-form').searchbox({
    url: '/search/',
    param: 'search',
    dom_id: '#livesearch',
    loading_css: '#livesearch_loading'
  });
}));

$(document).ready(function(){
  $('.languages li').click(function(e) {
    window.location = '/set_language/update?locale=' + $(this).attr('data-lang');
  });
});

$(document).ready(function(){
  $('.search_users').on('keyup', '#user_search', 
    function() {
      $.get($('#user_search').attr('action'),
      $('#user_search').serialize(), null, 'script');
      return false;
    }
  );
});
