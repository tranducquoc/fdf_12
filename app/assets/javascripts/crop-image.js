$(document).on('change', 'input#user_avatar', function(event){
  var input = $(event.currentTarget);
  var file = input[0].files[0];
  var reader = new FileReader();
  var img_tag = $('#img_user_avatar');
  reader.onload = function(e){
    var img = new Image();
    img.src = e.target.result;
    img.onload = function() {
      open_crop_image_modal(img.src, img_tag, '#crop_avatar_popup',
        '#user_avatar_crop', 1, 'input#user_avatar_crop_x', 'input#user_avatar_crop_y',
        'input#user_avatar_crop_w', 'input#user_avatar_crop_h' );
    }
  };
  reader.readAsDataURL(file);
});

$(document).on('change', 'input#shop_cover', function(event){
  var input = $(event.currentTarget);
  var file = input[0].files[0];
  var reader = new FileReader();
  var img_tag = $('.img_cover_crop');
  reader.onload = function(e){
    var img = new Image();
    img.src = e.target.result;
    img.onload = function() {
      open_crop_image_modal(img.src, img_tag, '#crop_cover_popup', '#shop_cover_crop', 21/9,
        'input#shop_cover_crop_x', 'input#shop_cover_crop_y', 'input#shop_cover_crop_w',
        'input#shop_cover_crop_h');
    }
  };
  reader.readAsDataURL(file);
});

$(document).on('change', 'input#shop_avatar', function(event){
  var input = $(event.currentTarget);
  var file = input[0].files[0];
  var reader = new FileReader();
  var img_tag = $('.img_shop_avatar');
  reader.onload = function(e){
    var img = new Image();
    img.src = e.target.result;
    img.onload = function() {
      open_crop_image_modal(img.src, img_tag, '#crop_avatar_shop', '#shop_avatar_crop', 1,
        'input#shop_crop_avatar_x', 'input#shop_crop_avatar_y', 'input#shop_crop_avatar_w',
        'input#shop_crop_avatar_h');
    }
  };
  reader.readAsDataURL(file);
});

$(document).on('change', 'input#product_crop', function(event){
  var input = $(event.currentTarget);
  var file = input[0].files[0];
  var reader = new FileReader();
  var img_tag = $('#img_product_crop');
  reader.onload = function(e){
    var img = new Image();
    img.src = e.target.result;
    img.onload = function() {
      open_crop_image_modal(img.src, img_tag, '#crop_product_popup', '#crop_product_img', 1,
        'input#product_crop_product_x', 'input#product_crop_product_y', 'input#product_crop_product_w',
        'input#product_crop_product_h');
    }
  };
  reader.readAsDataURL(file);
});

function open_crop_image_modal(img, img_tag, crop_popup_id, image_crop_id, ratio, crop_x, crop_y, crop_w, crop_h){
  $.magnificPopup.open({
    items: {
      type: 'inline',
      closeBtnInside: true,
      src: crop_popup_id
    },
    callbacks: {
      open: function() {
        $(crop_popup_id).show();
        $(image_crop_id).attr('src', img);
        $('.cropper-canvas img, .cropper-view-box img').attr('src', img);
        cropImage(image_crop_id, ratio, crop_x, crop_y, crop_w, crop_h);
        $('input#submit_crop').click(function(){
          $.magnificPopup.close();
        });
      },
      close: function() {
        var img = new Image();
        img.src = $(image_crop_id).cropper('getCroppedCanvas').toDataURL('image/png');
        img.onload = function() {
          var img_src = crop_image(img);
          img_tag.attr('src', img_src);
        }
        $(crop_popup_id).hide();
      }
    }
  });
}

function cropImage(image_crop_id, ratio, crop_x, crop_y, crop_w, crop_h){
  var $crop_x = $(crop_x),
    $crop_y = $(crop_y),
    $crop_w = $(crop_w),
    $crop_h = $(crop_h);
  $(image_crop_id).cropper({
    viewMode: 1,
    aspectRatio: ratio,
    background: false,
    zoomable: false,
    getData: true,
    built: function () {
      var croppedCanvas = $(this).cropper('getCroppedCanvas', {
        width: 100, // resize the cropped area
        height: 100
      });

      croppedCanvas.toDataURL(); // Get the 100 * 100 image.
    },
    crop: function(data) {
      $crop_x.val(Math.round(data.x));
      $crop_y.val(Math.round(data.y));
      $crop_h.val(Math.round(data.height));
      $crop_w.val(Math.round(data.width));
    }
  });
}

var crop_image = function(img) {
  var canvas = document.createElement('canvas');
  var ctx = canvas.getContext('2d');
  ctx.drawImage(img, 0, 0);

  var MAX_WIDTH = 800;
  var MAX_HEIGHT = 500;
  var width = img.width;
  var height = img.height;

  if (width > height) {
    if (width > MAX_WIDTH) {
      height *= MAX_WIDTH / width;
      width = MAX_WIDTH;
    }
  } else {
    if (height > MAX_HEIGHT) {
      width *= MAX_HEIGHT / height;
      height = MAX_HEIGHT;
    }
  }
  canvas.width = width;
  canvas.height = height;
  var ctx = canvas.getContext('2d');
  ctx.drawImage(img, 0, 0, width, height);
  return canvas.toDataURL('image/png');
}
