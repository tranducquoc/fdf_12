$(document).ready(function(){
  $(document).on('click','.btn-report', function(){
    var content = $('#ads-report').val();
    var post_id = $('#ads-report').data("post-id");
    $.ajax({
      url: '/reports',
      data: {
        post_id: post_id,
        report: {
          content: content,
        }
      },
      type: 'POST',
      dataType: 'script'
    });
  });
})
