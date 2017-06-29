$(document).ready ->
  $('#notifications-dropdown').click ->
    $('#notification_count')
      .css({opacity: 0})
      .text('')
      .css({top: '-10px'})
      .transition({top: '-2px', opacity: 1})
  $(document).on 'click', '.mark-read', ->
    link = $(this).data('link')
    current_link = window.location.pathname
    if link.indexOf("#") > 0
      edit_link = link.substr(0, link.indexOf("#"))
    else
      edit_link = link
    $.ajax
      type: 'PUT'
      url: '/events/' + $(this).data('id')
      success: (data) ->
        if edit_link == current_link
          window.location.reload()
        else
          window.location = link
        return
