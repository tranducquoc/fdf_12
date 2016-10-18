function iDontHaveName(btn) {
  var yourArray = [];
  var idOrders = [];
  var shopId = 5;
  $(".orders").find("input:checked").each(function (i, ob) {
    yourArray.push($(this).val());
    idOrders.push($(this).parent().children()[0].value);
  });
  var idItems = [];

  for (i = 0; i < idOrders.length; i++) {
    $('#order-' + idOrders[i] + ' tbody tr').each(function() {
      idItems.push($(this).children()[0].value);
    });
  }
  for (i = 0; i < idItems.length; i++) {
    $.ajax({
      type: 'PUT',
      url : '/dashboard/shops/' + shopId + '/order_products/' + idItems[i],
      dataType: 'json',
       data: {
        order_product: {
          status: $(btn).text()
        }
      },
      success: function(data) {
      },
      error: function(error_message) {
        alert('error ' + error_message);
      }
    });
  }
}
$(document).ready(function() {
  $('#checkbox').change(function() {
    if (this.checked) {
      $('.checkbox-abc').attr('checked', true);
      $( ".action" ).append( "<button class='list btn btn-primary btn-action' onclick='iDontHaveName(this)'>accepted</button>" );
      $( ".action" ).append( "<button class='list btn btn-danger btn-action' onclick='iDontHaveName(this)'>rejected</button>" );
      $( ".action" ).append( "<button class='list btn btn-success btn-action' onclick='iDontHaveName(this)'>done</button>" );

    } else {
      $('.checkbox-abc').attr('checked', false);
      $(".list").hide();
    }
  });
});

