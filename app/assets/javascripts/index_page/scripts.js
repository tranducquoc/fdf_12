jQuery(document).ready(function() {
  jQuery('.image-gallery').magnificPopup({
    delegate: '.item a',
    type:'image'
  });
  new WOW().init();
});
$(function(){
  $('nav.pushy a[href*=\\#]').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'')
      && location.hostname == this.hostname) {
      var $target = $(this.hash);
      $target = $target.length && $target || $('[name=' + this.hash.slice(1) +']');
      if ($target.length) {
        var targetOffset = $target.offset().top -0;
        $('html,body').animate({scrollTop: targetOffset}, 800);
        return false;
      }
    }
  });
});
