var dynamicFiles = [];
var existing_images = 0;
var deleted_images = 0;

$(document).ready(function(){
  existing_images = $('.existing_images input').length;
  var max = 3;
  var idx;
  $('.image-preview').on('click', '.image_view', function() {
    idx = $('.image_view').index(this);
  })

  $(document).on('change', '.img-file-input', function(event){
    var files = event.target.files;

    if (isMaxPictures(max)) {
      swal(I18n.t('ads.post.error.max_images', {number: max}), '', 'error');
    } else {
      for (var i = 0, file; file = files[i]; i++) {
        $('.image_view').eq(i + idx).addClass('dynamic_images');
        changePicture($('.image_view').eq(i + idx), file);
        dynamicFiles.push(file);
        if ($('.dynamic_images').length + existing_images < max) {
          $('#add-new-image').click();
        }
      }
    }

    $('.img-file-input')[0].value = "";

    function changePicture(element, file) {
      var reader = new FileReader();
      reader.onload = function (event) {
        $(element).attr('src', event.target.result);
      }
      reader.readAsDataURL(file);

      $(element).removeClass('input-image');
      $(element).siblings('.btn-remove').show()
    }

    function isMaxPictures(max) {
      return (files.length + dynamicFiles.length + existing_images) > max
    }
  });

  $(document).on('click', '.btn-remove', function(){
    deleted_images = $('.deleted_images').length;
    var idx = $('.btn-remove').index(this) - deleted_images - existing_images;
    dynamicFiles.splice(idx, 1);

    if ($('.input-image').length == 0){
      $('#add-new-image').click();
    }
    $(this).parent('.existing_images').removeClass('existing_images').addClass('deleted_images');
    deleted_images = $('.deleted_images').length;
    existing_images = $('.existing_images input').length;
  });

  $(document).on('click', '.input-image', function(){
    $('.img-file-input').trigger('click');
  });

  $('.existing').parents('.btn-remove').show();
})
