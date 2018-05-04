var modifiableFiles = [];

$(document).ready(function(){
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
        $('#add-new-image').click();
        changePicture($('.image_view').eq(i + idx), file);
        modifiableFiles.push(file);
      }
    }

    if ($('.image_view').length > 3) {
      $('.image_view:last').parent().remove();
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
      return (files.length + modifiableFiles.length) > max
    }
  });

  $(document).on('click', '.btn-remove', function(){
    idx = $('.btn-remove').index(this);
    modifiableFiles.splice(idx, 1);

    if ($('.input-image').length == 0){
      $('#add-new-image').click();
    }
  });

  $(document).on('click', '.input-image', function(){
    $('.img-file-input').trigger('click');
  });
})
