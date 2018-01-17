$(document).ready(function() {
  function setChecked(chkChecked1, chkChecked2, chkChecked3, chkChecked4, chkAll) {
    if (chkChecked1.is(':checked') && chkChecked2.is(':checked')
      && chkChecked3.is(':checked') && chkChecked4.is(':checked')) {
      chkAll.prop('checked', true);
    }
    else {
      chkAll.prop('checked', false);
    }
  };
  $(document).on('change', '#send_all_noti', function() {
    if ($(this).is(':checked')) {
      $('#send_turn_on_shop_noti').prop('checked', true);
      $('#send_turn_off_shop_noti').prop('checked', true);
      $('#send_order_status_noti').prop('checked', true);
      $('#send_new_product_noti').prop('checked', true);
    } else {
      $('#send_turn_on_shop_noti').prop('checked', false);
      $('#send_turn_off_shop_noti').prop('checked', false);
      $('#send_order_status_noti').prop('checked', false);
      $('#send_new_product_noti').prop('checked', false);
    }
  });
  $(document).on('change', '#send_turn_on_shop_noti', function() {
    setChecked($('#send_turn_on_shop_noti'), $('#send_turn_off_shop_noti'),
      $('#send_order_status_noti'), $('#send_new_product_noti'), $('#send_all_noti'));
  });
  $(document).on('change', '#send_turn_off_shop_noti', function() {
    setChecked($('#send_turn_off_shop_noti'), $('#send_turn_on_shop_noti'),
      $('#send_order_status_noti'), $('#send_new_product_noti'), $('#send_all_noti'));
  });
  $(document).on('change', '#send_new_product_noti', function() {
    setChecked($('#send_turn_on_shop_noti'), $('#send_turn_off_shop_noti'),
      $('#send_order_status_noti'), $('#send_new_product_noti'), $('#send_all_noti'));
  });
  $(document).on('change', '#send_order_status_noti', function() {
    setChecked($('#send_turn_off_shop_noti'), $('#send_turn_on_shop_noti'),
      $('#send_new_product_noti'), $('#send_order_status_noti'), $('#send_all_noti'));
  });
});
