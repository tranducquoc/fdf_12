$(document).ready(function() {
  var shop_id, modal_edit_shop;
  function load_image_shop(input, klass) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('.' + klass).attr('src', e.target.result);
      }
    reader.readAsDataURL(input.files[0]);
    }
  };
  $.validator.addMethod("shop_valid", function(value, element, regex) {
    return this.optional(element) || regex.test(value);
  }, I18n.t("activerecord.errors.models.shop.attributes.name.without"));
  $('#new_shop').validate({
    errorPlacement: function (error, element) {
      error.insertBefore(element);
    },
    rules: {
      'shop[name]': {
        required: true,
        maxlength: 50,
        shop_valid: /[a-zA-Z]/
      },
      'shop[description]': {
        required: true,
        maxlength: 250
      }
    },
    messages: {
      'shop[name]': {
        required: I18n.t('activerecord.errors.models.shop.attributes.name.blank'),
        maxlength: I18n.t('activerecord.errors.models.shop.attributes.name.too_long')
      },
      'shop[description]': {
        required: I18n.t('activerecord.errors.models.shop.attributes.description.blank'),
        maxlength: I18n.t('activerecord.errors.models.shop.attributes.description.too_long')
      }
    }
  });
  $('.btn-edit-shop').click(function() {
    shop_id = $(this).data('shop-id');
    modal_edit_shop = document.getElementById('modal_edit_shop_' + shop_id);
    $(modal_edit_shop).on('show.bs.modal', function() {
      var form_edit_shop = document.getElementById('edit_shop_' + shop_id);
      $(form_edit_shop).validate({
        errorPlacement: function (error, element) {
          error.insertBefore(element);
        },
        rules: {
          'shop[name]': {
            required: true,
            maxlength: 50
          },
          'shop[description]': {
            required: true,
            maxlength: 250
          }
        },
        messages: {
          'shop[name]': {
            required: I18n.t('activerecord.errors.models.shop.attributes.name.blank'),
            maxlength: I18n.t('activerecord.errors.models.shop.attributes.name.too_long')
          },
          'shop[description]': {
            required: I18n.t('activerecord.errors.models.shop.attributes.description.blank'),
            maxlength: I18n.t('activerecord.errors.models.shop.attributes.description.too_long')
          }
        }
      });
    });
  });
  $('.choose-avatar-shop').hover(function() {
    $('.choose-avatar-shop label').animate({'width': 'show'}, 400);
  }, function() {
    $('.choose-avatar-shop label').animate({'width': 'hide'}, 400);
  });
  $('.choose-cover-image-shop').hover(function() {
    $('.choose-cover-image-shop label').animate({'width': 'show'}, 400);
  }, function() {
    $('.choose-cover-image-shop label').animate({'width': 'hide'}, 400);
  });
  $('.choose-avatar-shop').click(function() {
    var file_field = $(this).parent().find('.upload-avatar-shop');
    file_field.click();
  });
  $('.choose-cover-image-shop').click(function() {
    var file_field = $(this).parent().find('.upload-cover-image-shop');
    file_field.click();
  });
  $('.upload-avatar-shop').on('change', function() {
    if (typeof shop_id === 'undefined') {
      load_image_shop(this, 'avatar-');
    } else {
      load_image_shop(this, 'avatar-' + shop_id);
    }
  });
  $('.upload-cover-image-shop').on('change', function() {
    if (typeof shop_id === 'undefined') {
      load_image_shop(this, 'cover-' + shop_id);
    } else {
      load_image_shop(this, 'cover-image-' + shop_id);
    }
  });
});
