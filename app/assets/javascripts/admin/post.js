$(document).ready(function () {
  $('.admin-search-post').keyup(function () {
    var key = $(this).val();
    var mode = $('#mode').val();
    var arena = $('#arena').val();
    var category_id = $('#category').val();
    $.ajax({
      type: 'GET',
      url : '/admin/posts',
      data: {
        key_search: key,
        mode_filter: mode,
        arena_filter: arena,
        category_id_filter: category_id
      }
    });
  });
  
  $('.change_flag').on('change', function() {
    var key = $('.admin-search-post').val();
    var mode = $('#mode').val();
    var arena = $('#arena').val();
    var category_id = $('#category').val();
    $.ajax({
      type: 'GET',
      url : '/admin/posts',
      data: {
        key_search: key,
        mode_filter: mode,
        arena_filter: arena,
        category_id_filter: category_id
      }
    });
  })
});
