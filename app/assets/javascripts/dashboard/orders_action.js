function iDontHaveName(btn) {
  var yourArray = [];
  var idOrders = [];
  var shopId = $("#shop-id").val();
  $(".orders").find("input:checked").each(function (i, ob) {
    yourArray.push($(this).val());
    idOrders.push($(this).parent().children()[0].value);
  });
  var idItems = [];
  var classes = ["label-info", "label-warning", "label-danger", "label-primary"];
  var actions = ["pending", "accepted", "rejected", "done"];
  for (i = 0; i < idOrders.length; i++) {
    $('#order-' + idOrders[i] + ' tbody tr').each(function() {
      idItems.push($(this).children()[0].value);
    });
  }

  $.each(idOrders, function( index, value ) {
    $.ajax({
      type: 'PUT',
      url : '/dashboard/shops/' + shopId + '/orders/' + value,
      dataType: 'json',
       data: {
        order: {
          status: $(btn).text()
        }
      },
      success: function(data) {
        var klass = '#status-' + value + ' span';
        $(klass).text($(btn).text());
        var currentClass = $(klass).attr('class').split(" ")[1];
        $(klass).removeClass(currentClass).addClass(classes[actions.indexOf($(btn).text())]);
      },
      error: function(error_message) {
        alert('error ' + error_message);
      }
    });
  });

  $.each(idItems, function( index, value ) {
    $.ajax({
      type: 'PUT',
      url : '/dashboard/shops/' + shopId + '/order_products/' + value,
      dataType: 'json',
       data: {
        order_product: {
          status: $(btn).text()
        }
      },
      success: function(data) {
        var klass = '.order-product-status-' + value + ' span';
        $(klass).text($(btn).text());
        console.log(value);
        $("#status-order-"+ value).prop("selectedIndex", actions.indexOf($(btn).text()));
        var currentClass = $(klass).attr('class').split(" ")[1];
        $(klass).removeClass(currentClass).addClass(classes[actions.indexOf($(btn).text())]);
      },
      error: function(error_message) {
        alert('error ' + error_message);
      }
    });
  });

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

