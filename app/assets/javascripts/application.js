// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs
//= require star-rating.min
//= require bootstrap
//= require jquery.raty
//= require ratyrate
//= require bootstrap-tagsinput
//= require jquery.slimscroll
//= require app
//= require Chart.bundle
//= require chartkick
//= require datetimepicker
//= require growl
//= require jquery.transit.min
//= require_tree .
//= require social-share-button
//= require i18n
//= require i18n.js
//= require i18n/translations
//= require sweetalert/dist/sweetalert.min.js
//= require owl.carousel/dist/owl.carousel.min.js
//= require ion.rangeSlider/js/ion.rangeSlider.js
//= require jquery.validate
//= require cropper
//= require magnific-popup
//= require dropzone
//= require cocoon

$(document).ready(function () {
  $('.alert').fadeOut(5000);

  $('.grid-format').click(function(){
    $('.grid-format').addClass('active');
    $('.list-format').removeClass('active');
    $('.ads-item-wrap').addClass('grid-view');
  });

  $('.list-format').click(function(){
    $('.grid-format').removeClass('active');
    $('.list-format').addClass('active');
    $('.ads-item-wrap').removeClass('grid-view');
  });

  $('#category_parent_id option:first-child').val('0');

  $('.parent-id-edit option:first-child').val($('.parent-id-0').val());

  var prevScrollpos = window.pageYOffset;
  window.onscroll = function() {
    var currentScrollPos = window.pageYOffset;
    if (prevScrollpos > currentScrollPos) {
      $('.main-nav').css('top', '0');
      $('.go-to').css('top', '80px');

    } else {
      $('.main-nav').css('top', '-35px')
      $('.go-to').css('top', '45px');
    }
    prevScrollpos = currentScrollPos;
  }
});
