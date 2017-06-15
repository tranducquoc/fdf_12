$(document).ready ->
  $('#notifications-dropdown').click ->
    $('#notification_count')
      .css({opacity: 0})
      .text('')
      .css({top: '-10px'})
      .transition({top: '-2px', opacity: 1})
    $('.mark-read').click ->
      $.ajax
        type: 'PUT'
        url: '/events/' + $(this).data('id')
        dataType: 'json'
