$(document).ready(function(){
  $(document).on('change', '.img-file-input', function(event){
    var input = $(event.currentTarget);
    var file = input[0].files[0];
    var reader = new FileReader();
    input = this;
    reader.onload = function (e) {
      $(input).parents('.nested-fields').find('.image_view').attr('src', e.target.result);
    }
    reader.readAsDataURL(file);

    self = $(this).parents('.list-gallery').find('.image_view');
    $(this).parents('.list-gallery').find('.btn-remove').show();
    var check = false;
    $('.image_view').each(function(){
      if ($(this).attr('src').split('/')[1].toString() === 'assets' && this != self[0]){
        check = true;
      }
    });
    if (check === false) {
      $('#add-new-image').click();
      $('#image-list-preview .list-gallery:nth-last-child(2)').find('.btn-remove').hide();
    }

  });
  $(document).on('click', '.btn-remove', function(){
    if ($('.image_view').length == 3){
      $('#add-new-image').click();
    }
  });
  $(document).on('click', '.image_view', function(){
    $(this).parents('.list-gallery').find('.img-file-input').trigger('click');
  });
})
