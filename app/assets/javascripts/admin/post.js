$(document).ready(function () {
  $('.admin-search-post').keyup(function () {
    var key = $(this).val();
    $.ajax({
      type: 'GET',
      url : '/admin/posts',
      data: {
        key_search: key
      }
    });
  });
});
