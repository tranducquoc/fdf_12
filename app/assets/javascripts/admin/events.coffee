$(document).ready ->
  $(document).on 'click', '.mark-read-admin', ->
    link = $(this).data('link')
    current_link = window.location.pathname
    if link.indexOf("#") > 0
      edit_link = link.substr(0, link.indexOf("#"))
    else
      edit_link = link
    $.ajax
      type: 'PUT'
      url: '/admin/events/' + $(this).data('id')
      success: (data) ->
        window.location = link
