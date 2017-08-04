$(document).ready(function() {
  var all_notification = $('#turn-all-notification');
  var all_email = $('#turn-all-email');
  var all_chatwork = $('#turn-all-chatwork');
  var notification_request = $('#turn-order-request-notification');
  var notification_processed = $('#turn-order-processed-notification');
  var notification_order = $('#turn-send-order-notification');
  var email_request = $('#turn-order-request-email');
  var email_processed = $('#turn-order-processed-email');
  var email_order = $('#turn-send-order-email');
  var chatwork_processed = $('#turn-order-processed-chatwork')
  var chatwork_shop = $('#turn-shop-open-chatwork')
  function setChecked(chkChecked1, chkChecked2, chkChecked3, chkAll) {
    if (chkChecked1.is(':checked')) {
      if (chkChecked3 != '') {
        if (chkChecked2.is(':checked') && chkChecked3.is(':checked')) {
          chkAll.prop('checked', true);
        }
      }
      else {
        if (chkChecked2.is(':checked'))
          chkAll.prop('checked', true);
      }
    }
    else {
      chkAll.prop('checked', false);
    }
  };
  all_notification.on('change', function() {
    if ($(this).is(':checked')) {
      notification_request.prop('checked', true);
      notification_processed.prop('checked', true);
      notification_order.prop('checked', true);
    } else {
      notification_request.prop('checked', false);
      notification_processed.prop('checked', false);
      notification_order.prop('checked', false);
    }
  });
  all_email.on('change', function() {
    if ($(this).is(':checked')) {
      email_request.prop('checked', true);
      email_processed.prop('checked', true);
      email_order.prop('checked', true);
    } else {
      email_request.prop('checked', false);
      email_processed.prop('checked', false);
      email_order.prop('checked', false);
    }
  });
  all_chatwork.on('change', function() {
    if ($(this).is(':checked')) {
      chatwork_processed.prop('checked', true);
      chatwork_shop.prop('checked', true);
    } else {
      chatwork_processed.prop('checked', false);
      chatwork_shop.prop('checked', false);
    }
  });
  notification_request.on('change', function() {
    setChecked(notification_request, notification_processed,
      notification_order, all_notification);
  });
  notification_processed.on('change', function() {
    setChecked(notification_processed, notification_request,
      notification_order, all_notification);
  });
  notification_order.on('change', function() {
    setChecked(notification_order, notification_processed,
      notification_request, all_notification);
  });
  email_request.on('change', function() {
    setChecked(email_request, email_processed, email_order, all_email);
  });
  email_processed.on('change', function() {
    setChecked(email_processed, email_request, email_order, all_email);
  });
  email_order.on('change', function() {
    setChecked(email_order, email_processed, email_request, all_email);
  });
  chatwork_processed.on('change', function() {
    setChecked(chatwork_processed, chatwork_shop, '', all_chatwork);
  });
  chatwork_shop.on('change', function() {
    setChecked(chatwork_shop, chatwork_processed, '', all_chatwork);
  });
});
