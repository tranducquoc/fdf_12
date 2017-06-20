$(document).ready(function() {
  $('.id_btn_active').on('click', function() {
    statusNow = $(this).val();
    btn = $(this);
    statusChange = (statusNow === 'active') ? 'inactive' : 'active';
    parent = $(this).parent(),
    productId =  parent.children()[0].value,
    $.ajax({
      type: 'PUT',
      url : '/dashboard/shops/' + $('.shop_id').val() + '/products/'+ productId,
      dataType: 'json',
       data: {
        product: {
          status: statusChange
        }
      },
      success: function(data) {
        btn.val(statusChange);
      },
      error: function(error_message) {
        Console.log('error: ' + error_message);
      }
    });
  });
  function load_image(input, klass) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('.' + klass).attr('src', e.target.result);
      }
    reader.readAsDataURL(input.files[0]);
    }
  };
  function choose_image() {
    var file_field;
    $('.choose-avatar').hover(function() {
      $('.choose-avatar label').animate({'width': 'show'}, 400);
    }, function() {
      $('.choose-avatar label').animate({'width': 'hide'}, 400);
    });
    $('.choose-avatar').click(function() {
      file_field = $(this).parent().find('.upload_img');
      file_field.click();
    });
    $('.upload_img').on('change', function() {
      file_name = this.files.item(0).name;
      $('.choose-avatar label').html(file_name);
      load_image(this, 'product-avatar');
    });
  };
  $('#new-edit-product-modal').on('shown.bs.modal', function() {
    $('.btn-back-to-shop').click(function(e) {
      e.preventDefault();
      $('#new-edit-product-modal').modal('hide');
    });
    choose_image();
  });
  choose_image();
});
