$(document).ready(function(){
  var price = 0;
  var product = null;
  $('.btn_modal_order_now').click(function(){
    product = $(this).data('product');
    price = product.price;
    document.getElementById("modal_image").src = product.image.url;
    $('#modal_name').html(product.name);
    $('#modal_price').html(price.toLocaleString() + I18n.t("cart.vnd"));
    var quantity = $('#modal_quantity').html('1');
    $('#modal_total').html(price.toLocaleString() + I18n.t("cart.vnd"));
  });

  $('.modal_quantity_up').click(function(){
    var quantity = parseInt($('#modal_quantity').html());
    if(quantity < 30){
      $('#modal_quantity').html(quantity + 1);
      $('#modal_total').html(((quantity + 1) * price).toLocaleString() + I18n.t("cart.vnd"));
    }
  });

  $('.modal_quantity_down').click(function(){
    var quantity = parseInt($('#modal_quantity').html());
    if(quantity > 1) {
      $('#modal_quantity').html(quantity - 1);
      $('#modal_total').html(((quantity - 1) * price).toLocaleString() + I18n.t("cart.vnd"));
    }
  });

  $('#finish_order_fast').click(function(){
    var quantity = $('#modal_quantity').html();
    var note = $('#modal_note').val();
    $.ajax({
      type: 'POST',
      url : '/order_fasts',
      dataType: 'json',
      context: this,
      data: {
        product_id: product.id,
        note: note,
        quantity: quantity
      },
      success: function(response) {
        if(response.url == '') {
          window.location.reload();
        }
        else {
          window.location = response.url;
        }
      },
      error: function(errors) {
        window.location.reload();
      }
    });
  });
});

$(document).ready(function(){
  $('.update_notes_cart').click(function(){
    $(this).closest('.hide_show').find('.content_note_item_cart').slideToggle(800);
  });

  $('.content_note_cancel').click(function(){
    $(this).closest('.hide_show').find('.content_note_item_cart').slideToggle(800);
  });

  $('.content_note_save').click(function(){
    var note = $(this).closest('.content_note_item_cart').find('.content_note').val();
    var domain_id = $(this).closest('.cart-item-show').data('id');
    var product_id = $(this).closest('a').data('id');
    $.ajax({
      type: 'PUT',
      url : '/carts/1',
      dataType: 'json',
      context: this,
      data: {
        type_notes: "notes",
        product_id: product_id,
        notes: note
      },
      success: function(response) {
        $(this).closest('.content_note_item_cart').hide(800);
      },
      error: function(errors) {
        alert(I18n.t('order_quick.save_fail'));
      }
    });
  });
});

$(document).ready(function(){
  $('#search').keyup(function(){
    $('#search_owner_form').submit();
  });
});

$(document).ready(function() {
  $('input[type=radio][name=filter_order]').change(function() {
    $(this).parent('a').get(0).click();
  });
});

$(document).ready(function(){
  $('.btn_edit_domain').click(function(){
    var id = $(this).parent('td').data('domain-id');
    var name = $(this).parent('td').data('domain-name');
    var status = $(this).parent('td').data('domain-status');
    $('.edit_domain_name').val(name);
    $('.edit_domain_name').parents('form').attr('action', '/domains/' + id + '/edit');
    if(status === 'professed') {
      $('.edit_domain_status').find('option[value="' + status + '"]').attr("selected",true);
      $('.edit_domain_status').find('option[value="secret"]').removeAttr("selected");
    }
    else {
      $('.edit_domain_status').find('option[value="' + status + '"]').attr("selected",true);
      $('.edit_domain_status').find('option[value="professed"]').removeAttr("selected");
    }
  });
});

$(document).ready(function(){
  function compare_current_date(date_s) {
    date_list = date_s.split('/');
    date = new Date(date_list[2], date_list[0], date_list[1]);
    var currentDate = new Date();
    if (date.getDate() <= currentDate.getDate())
      return true
    else
      return false
  };

  function compare_dates(date_s1, date_s2) {
    date_list1 = date_s1.split('/');
    date_list2 = date_s2.split('/');
    date1 = new Date(date_list1[2], date_list1[0], date_list1[1]);
    date2 = new Date(date_list2[2], date_list2[0], date_list2[1]);
    if (date1.getDate() <= date2.getDate())
      return true
    else
      return false
  };

  var start = null;
  var end = null;

  $('.datepicker_ordermanager_start').change(function(){
    var value_start = $(this).val();
    if(value_start != '' && value_start != start) {
      start = value_start;
      if(compare_current_date(value_start) === false) {
        sweetAlert(I18n.t('api.error'), I18n.t('datepicker.rather_than_current_date'), 'error');
        $(this).val('');
        start = '';
      }
    }
  });

  $('.datepicker_ordermanager_end').change(function(){
    var value_start = $('.datepicker_ordermanager_start').val();
    if(value_start === '') {
      sweetAlert(I18n.t('api.error'), I18n.t('datepicker.date_start_nil'), 'error');
      $(this).val('');
      end = '';
    }
    else {
      var value_end = $(this).val();
      if(value_end != '' && value_end != end) {
        end = value_end;
        if(compare_current_date(value_end) === false) {
          sweetAlert(I18n.t('api.error'), I18n.t('datepicker.rather_than_current_date'), 'error');
          $(this).val('');
          end = '';
        }
        else {
          if(compare_dates(value_start, value_end) === false) {
            sweetAlert(I18n.t('api.error'),
              I18n.t('datepicker.date_start_rather_than_date_end'), 'error');
            $(this).val('');
            end = '';
          }
        }
      }
    }
  });
});

$(document).ready(function(){
  $('.owl-carousel').owlCarousel({
    items: 3,
    loop: true,
    autoplay: true,
    autoPlaySpeed: 5000,
    autoPlayTimeout: 5000,
    autoplayHoverPause: false
  });
});

$(document).ready(function(){
  $('.top-shop-slide-item').hover(function(){
    $(this).find('.toggle_panel').slideToggle(500);
  });

  $('.all-shop-slide-item').hover(function(){
    $(this).find('.toggle_panel').slideToggle(500);
  });
});

// open/close shop
$(document).ready(function(){
  $('.btn-open-close-shop').click(function(){
    var btn = $(this);
    var type = btn.data('type');
    if(type === 'close') {
      $.ajax({
        url: '/dashboard/shops/' + $(this).data('id'),
        type: 'PUT',
        dataType: 'script',
        data: {
          'checked': false
        },
        success: function(response) {
          sweetAlert(I18n.t('api.success'), I18n.t('shop_was_closed'), 'success');
          btn.data('type', 'open');
          btn.html('<div class="btn_icon material-icons">lock_open</div><div><%= I18n.t("general_info.open_shop_now") %></div>');
        },
        error: function(errors) {
          sweetAlert(I18n.t('api.error'), I18n.t('api.error'), 'error');
        }
      });
    }
    else {
      $.ajax({
        url: '/dashboard/shops/' + $(this).data('id'),
        type: 'PUT',
        dataType: 'script',
        data:{
          'checked': true
        },
        success: function(response) {
          sweetAlert(I18n.t('api.success'), I18n.t('shop_was_open'), 'success');
          btn.data('type', 'close');
          btn.html('<div class="btn_icon material-icons">lock_outline</div><div><%= I18n.t("general_info.close_shop_now") %></div>');
        },
        error: function(errors) {
          sweetAlert(I18n.t('api.error'), I18n.t('api.error'), 'error');
        }
      });
    }
  });
});

$(document).ready(function(){
  $('#shop_openforever').change(function(){
    $('.time_auto_close_shop').slideToggle(500);
  });
});
