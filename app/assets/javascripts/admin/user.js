$(document).ready(function() {
  $('.choose-xls-file').click(function() {
    $(this).parent().find('#file').click();
  });
  search_user();
});

function search_user() {
  $('.admin-search-user').keyup(function(){
    var key = $(this).val();
    $.ajax({
      type: 'GET',
      url : '/admin/users',
      data: {
        search: true,
        key_search: key
      }
    });
  });
}
