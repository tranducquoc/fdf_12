$(document).ready(function(){
  $('.btn-view-detail-domain').click(function(){
    var id = $(this).data('id');
    $.ajax({
      type: 'GET',
      url : '/admin/domains/'+ id,
      dataType: 'json',
      success: function(response) {
        $.each(response.users, function(key, value){
          $('#table-list-members').append('<tr><td>' + (key + 1) + '</td><td>' +
            value + '</td></tr>')
        });
        $.each(response.shops, function(key, value){
          $('#table-list-shops').append('<tr><td>' + (key + 1) + '</td><td>' +
            value + '</td></tr>')
        });
      },
      error: function(errors) {
        alert(I18n.t('order_quick.save_fail'));
      }
    });
  });
});
