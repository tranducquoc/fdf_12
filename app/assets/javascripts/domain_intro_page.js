$(function(){
  $('.btn-circle').on('click', function(){
    var clickedButtonIdx = $('.btn-circle').index(this);
    var buttonInfoIdx = $('.btn-circle').index($('.btn-info'));

    if(buttonInfoIdx < clickedButtonIdx) {
      $('.next-step').eq(buttonInfoIdx).trigger('click');
    } else if (buttonInfoIdx > clickedButtonIdx) {
      $('.prev-step').trigger('click');
    } else {
      $(this).tab('show');
    }
  });

  $('.next-step').on('click', function (e){
    var $activeTab = $('.tab-pane.active');
    if ($activeTab.is($('#menu2'))) {
      var isValidTab = true;
      $('.input-compulsory').each(function () {
        if (!isValidField($(this))) {
          changeClasses(this, 'green-field', 'red-field');
          isValidTab = false;
        }
      });
      if (!isValidTab) {
        swal(I18n.t('ads.post.error.invalid_fields'), '', 'error');
        return;
      }
    }
    var nextTab = $('.tab-pane.active').next('.tab-pane').attr('id');
    changeActiveToTab(nextTab);
  });

  $('.prev-step').on('click', function (e){
    var prevTab = $('.tab-pane.active').prev('.tab-pane').attr('id');
    changeActiveToTab(prevTab);
  });

  $('.input-compulsory').each(function () {
    $(this).on('blur', function () {
      if (isValidField($(this)))
        changeClasses(this, 'red-field', 'green-field');
      else
        changeClasses(this, 'green-field', 'red-field');
    });
  });

  function isValidField(field) {
    if($(field).is($('#post-title'))) {
      var postTitleLength = $(field).val().length;
      var minTitle = 5;
      var maxTitle = 150;
      return !((postTitleLength < minTitle) || (postTitleLength > maxTitle));
    } else if($(field).is($('#post_min_price')) || $(field).is($('#post_max_price'))) {
      var minPrice = parseInt($('#post_min_price').val());
      var maxPrice = parseInt($('#post_max_price').val());

      if (isValidPriceRange(minPrice, maxPrice, 1000, 100000000))
        return true;
      else
        return false;
    } else
      return !($(field).val() === '');
  }

  function changeActiveToTab(tab) {
    $('.btn-circle.btn-info').removeClass('btn-info').addClass('btn-default');
    $('[href="#'+ tab +'"]').addClass('btn-info').removeClass('btn-default');
    $('[href="#'+ tab +'"]').tab('show');
  }

  function changeClasses(element, oldClass, newClass) {
    if ($(element).is($('#post_min_price')) || $(element).is($('#post_max_price'))) {
      changeClass('#post_min_price', oldClass, newClass);
      changeClass('#post_max_price', oldClass, newClass);
    } else {
      changeClass(element, oldClass, newClass);
    }
  }

  function changeClass(element, oldClass, newClass) {
    if ($(element).hasClass(oldClass)) {
      $(element).removeClass(oldClass);
      $(element).addClass(newClass);
    } else
      $(element).addClass(newClass);
  }

  function isValidPriceRange(min, max, minValue, maxValue) {
    if ((min <= max) && (minValue <= min && min <= maxValue) && (minValue <= max && max <= maxValue)) {
      return true;
    }
    return false;
  }
});
