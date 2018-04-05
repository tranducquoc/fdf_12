$(document).ready(function(){
  var max = 3;
  var idx;
  $('.image-preview').on('click', '.image_view', function() {
    idx = $('.image_view').index(this);
  })

  $(document).on('change', '.img-file-input', function(event){
    var files = event.target.files;
    var lengthOfImageView = $('.has-picture').length;

    if (isMaxPictures(max)) {
      swal(I18n.t('ads.post.error.max_images', {number: max}), '', 'error');
    } else {
      for (var i = 0, file; file = files[i]; i++) {
        $('#add-new-image').click();
        changePicture($('.image_view').eq(i + idx), file);
      }
    }

    if ($('.image_view').length > 3) {
      $('.image_view:last').parent().remove();
    }

    function changePicture(element, file) {
      var reader = new FileReader();
      reader.onload = function (event) {
        $(element).attr('src', event.target.result);
      }
      reader.readAsDataURL(file);

      $(element).addClass('has-picture');
      $(element).siblings('.btn-remove').show()
    }

    function isMaxPictures(max) {
      return (files.length + lengthOfImageView) > max
    }
  });

  $(document).on('click', '.btn-remove', function(){
    if ($('.has-picture').length == 3){
      $('#add-new-image').click();
    }
  });

  $(document).on('click', '.image_view', function(){
    $(this).parents('.list-gallery').find('.img-file-input').trigger('click');
  });
})
