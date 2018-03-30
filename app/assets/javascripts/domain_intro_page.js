$(function(){
  $('.btn-circle').on('click',function(){
    var empty_fields = '';
    $('.field-compulsory').each(function (index) {
      empty_fields += ((index + 1) == $('.field-compulsory').length) ? $(this).text() : $(this).text() + ',  ';
    });

    if(is_valid('.input-compulsory')) {
      $('.btn-circle.btn-info').removeClass('btn-info').addClass('btn-default');
      $(this).addClass('btn-info').removeClass('btn-default').blur();
    } else
      swal(I18n.t('ads.post.error.empty_field', {field: empty_fields}), '', 'error');
  });

  $('.next-step').on('click', function (e){
    var empty_fields = '';
    $('.field-compulsory').each(function (index) {
      empty_fields += ((index + 1) == $('.field-compulsory').length) ? $(this).text() : $(this).text() + ',  ';
    });

    var $activeTab = $('.tab-pane.active');

    if(is_valid('.input-compulsory')) {
      $('.btn-circle.btn-info').removeClass('btn-info').addClass('btn-default');

      if ($(e.target).hasClass('next-step'))
      {
        var nextTab = $activeTab.next('.tab-pane').attr('id');
        $('[href="#'+ nextTab +'"]').addClass('btn-info').removeClass('btn-default');
        $('[href="#'+ nextTab +'"]').tab('show');
      }
    } else
      swal(I18n.t('ads.post.error.empty_field', {field: empty_fields}), '', 'error');
  });

  $('.prev-step').on('click', function (e){
    var $activeTab = $('.tab-pane.active');

    $('.btn-circle.btn-info').removeClass('btn-info').addClass('btn-default');

    var prevTab = $activeTab.prev('.tab-pane').attr('id');
    $('[href="#'+ prevTab +'"]').addClass('btn-info').removeClass('btn-default');
    $('[href="#'+ prevTab +'"]').tab('show');
  });

  function is_valid(field) {
    var isValid = true;

    $(field).each(function() {
      if(($('#menu2').html() == $('.tab-pane.active').html()) && ($(this).val() === '')) {
        isValid = false;
      }
    });
    return isValid;
  }
});
