$(document).ready(function() {

  $('.order-history-date').on('change', function() {
    filter_order();
  });

  $('.order-history-status').on('click', function() {
    filter_order();
  });

  function filter_order() {
    var end_date = $('.order-history-end').val();
    var start_date = $('.order-history-start').val();
    var status = $('input[name=history_order_status]:checked').val();
    if(start_date && end_date && start_date > end_date) {
      sweetAlert(I18n.t('api.error'),
        I18n.t('datepicker.date_start_rather_than_date_end'), 'error');
      return false;
    } else {
      $.ajax({
        url: $(this).attr('action'),
        type: 'GET',
        data: {
          status: status,
          start_date: start_date,
          end_date: end_date
        }
      });
    }
  };
});
