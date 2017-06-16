$(document).ready(function(){

  $('.order-manager-datepicker').datetimepicker({
    timepicker: false,
    format: 'd-m-Y'
  });

  $('#filter-order-manager').on('change', function(){
    $.ajax({
      url: $(this).attr('action'),
      type: 'GET',
      data:{
        domain_id: $(this).val(),
        type: $('input[name=status]:checked').val(),
        user_search: $('#order_by_user').val()
      }
    });
  });

  $('.manage-order-status').on('click', function(){
    $.ajax({
      url: $(this).attr('action'),
      type: 'GET',
      data: {
        type: $(this).val(),
        domain_id: $('#filter-order-manager').val(),
        user_search: $('#order_by_user').val()
      }
    });
  });

  $('#order_by_user').on('keyup',function() {
    $.ajax({
      url: $(this).attr('action'),
      type: 'GET',
      data: {
        user_search: $(this).val(),
        domain_id: $('#filter-order-manager').val(),
        type: $('input[name=status]:checked').val()
      }
    });
  });

  function filter_order() {
    var shop_id = $('#shop_id').val();
    var type = $('#history-order-manager').val();
    if (type === 'product') {
      url = $(this).attr('action');
    } else {
      url = '/dashboard/shops/' + shop_id + '/user_orders'
    }
    var end_date = $('.order-manager-end').val();
    var start_date = $('.order-manager-start').val();
    if (start_date && end_date && start_date > end_date){
      sweetAlert(I18n.t('api.error'),
        I18n.t('datepicker.date_start_rather_than_date_end'), 'error');
      return false;
    } else {
      $.ajax({
        url: url,
        type: 'GET',
        data: {
          type: type,
          shop_id: shop_id,
          start_date: start_date,
          end_date: end_date
        }
      });
    }
  };

  $('#history-order-manager').on('change', function(){
    filter_order()
  });

  $('.order-manager-date').on('change', function() {
    filter_order()
  })
});
