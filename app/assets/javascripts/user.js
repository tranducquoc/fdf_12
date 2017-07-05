$(document).ready(function() {
  function load_user_avatar(input, klass) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function(e) {
        $('.' + klass).attr('src', e.target.result);
      }
    reader.readAsDataURL(input.files[0]);
    }
  };
  $('.choose-avatar').hover(function() {
    $('.choose-avatar label').animate({'width': 'show'}, 400);
  }, function() {
    $('.choose-avatar label').animate({'width': 'hide'}, 400);
  });
  $('.choose-avatar').click(function() {
    var file_field = $(this).parent().find('.upload-user-avatar');
    file_field.click();
  });
  $('.upload-user-avatar').on('change', function() {
    load_user_avatar(this, 'avatar-show-user');
  });
  $.validator.addMethod('valid_user_name', function(value, element, regex) {
    return this.optional(element) || regex.test(value);
  }, I18n.t('activerecord.errors.models.user.attributes.name.without'));
  $('#edit_user').validate({
    errorPlacement: function (error, element) {
      error.insertBefore(element);
    },
    rules: {
      'user[name]': {
        required: true,
        maxlength: 50,
        valid_user_name: /^[^!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?\d]+$/
      },
      'user[description]': {
        maxlength: 50
      },
      'user[address]': {
        maxlength: 50
      },
      'user[chatwork_id]': {
        maxlength: 50
      }
    },
    messages: {
      'user[name]': {
        required: I18n.t('activerecord.errors.models.user.attributes.name.blank'),
        maxlength: I18n.t('activerecord.errors.models.user.attributes.name.too_long')
      },
      'user[description]': {
        maxlength: I18n.t('activerecord.errors.models.user.attributes.description.too_long')
      },
      'user[address]': {
        maxlength: I18n.t('activerecord.errors.models.user.attributes.address.too_long'),
      },
      'user[chatwork_id]': {
        maxlength: I18n.t('activerecord.errors.models.user.attributes.chatwork_id.too_long'),
      }
    }
  });
  $('.change-password-user').validate({
    errorPlacement: function (error, element) {
      error.insertBefore(element);
    },
    rules: {
      'user[password]': {
        required: true,
        minlength: 6
      },
      'user[password_confirmation]': {
        required: true,
        equalTo: "#user_password"
      }
    },
    messages: {
      'user[password]': {
        required: I18n.t('activerecord.errors.models.user.attributes.password.blank'),
        minlength: I18n.t('activerecord.errors.models.user.attributes.password.too_short')
      },
      'user[password_confirmation]': {
        required: I18n.t('activerecord.errors.models.user.attributes.password_confirmation.blank'),
        equalTo: I18n.t('activerecord.errors.models.user.attributes.password_confirmation.confirmation')
      }
    }
  });
  $('#change-password-user').on('hidden.bs.modal', function() {
    $('#user_password').val('');
    $('#user_password_confirmation').val('');
    $('#user_current_password').val('');
    $('#user_password-error').html('');
    $('#user_password_confirmation-error').html('');
    $('strong.time-error').html('');
  });
});
