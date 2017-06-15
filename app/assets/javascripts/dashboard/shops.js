$(document).ready(function(){
  $('#id_shops_list').find('input.onoffswitch-checkbox').each(function(index, input){
    $(input).on('change', function(){
      if($(input).is(':checked')){
        $.ajax({
          url: '/dashboard/shops/' + $(this).attr('value'),
          type: 'PUT',
          dataType: 'script',
          data:{
            'checked': true
          },
        });
      }
      else {
        $.ajax({
          url: '/dashboard/shops/' + $(this).attr('value'),
          type: 'PUT',
          dataType: 'script',
          data:{
            'checked': false
          },
        });
      }
    })
  })
});
