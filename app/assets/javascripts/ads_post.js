$(document).ready(function(){
  $(document).on('click','.btn-review',function(){
    var review = $('#ads-review').val();
    var post_id = $('#ads-review').data("post-id");
    $.ajax({
      url: '/reviews',
      data: {
        post_id: post_id,
        review: {
          review: review,
        }
      },
      type: 'POST',
      dataType: 'script'
    });
  });
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
