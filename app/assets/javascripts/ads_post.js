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

  $(document).on('click', '#approve_post, #block_post', function() {
    var url = $(this).attr('data-url');
    var status = $(this).attr('data-value');

    $.ajax({
      url: url,
      data: {
        post: {
          status: status
        }
      },
      type: 'PATCH',
      dataType: 'script',
      success: function() {
        swal(I18n.t("admin.reports.update.success"), "", "success");
      },
      error: function() {
        swal(I18n.t("admin.reports.update.failed"), "", "error");
      }
    });
  });
})
