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

  $(document).on('click', '.carousel-inner > .active', function() {
    var post_url = $(this).attr('data-top-post');
    window.location.href = post_url;
  });

  $(document).on('mouseenter', '.top-post-screen-shots > img', function() {
    var image_url = $(this).attr('src');

    if (image_url !== $('.carousel-inner > .active > img').attr('src')) {
      $('.carousel-inner > .active > img').fadeOut(225, function() {
        $(this).attr('src', image_url);
        $(this).fadeIn(225);
      });
    }
  });

  $(document).on('mouseenter', '.ads-posts', function() {
    var adsPosts = $(this);

    if (!isHovered(adsPosts)) {
      $('.index-right-sidebar').fadeOut(225, function() {
        $(this).html('');

        $(adsPosts).find('input[id="post_images"]').each(function() {
          var indexRightImages =
            '<div class="index-right-images">' +
              '<img src="' + $(this).attr('value') + '">' +
            '</div>';

          $('.index-right-sidebar').append(indexRightImages);
        });

        $(this).fadeIn(225);
      });
    }

    function isHovered(adsPosts) {
      var firstImage = $(adsPosts).find('input[id="post_images"]').attr('value');
      var firstScreenShotImage = $('.index-right-sidebar > .index-right-images > img').attr('src');

      return firstImage == firstScreenShotImage;
    }
  });
})
