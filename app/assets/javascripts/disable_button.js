$(document).ready(function(){
  $(document).on('click', '.disable-button', function(){
    $(this).attr('disabled','disabled');
    $('.disable-accept').css('cursor', 'not-allowed');
  })
});
