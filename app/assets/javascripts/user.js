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
});
