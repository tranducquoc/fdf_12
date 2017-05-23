$(document).ready(function() {
  var time = 5;
  function timeButton(time) {
    var text = I18n.t("automatic_go_to", {time: time});
    $('p.timer').html(text);
    timer = setTimeout(function() {
      time--;
      timeButton(time);
    }, 1000);
    if (time == 0) {
      clearTimeout(timer);
      $('.confirm-no').get(0).click();
    };
  };
  $('.confirm-button').click(function() {
    time = 5;
    timeButton(time);
  });
  $('#modal-confirm').on('hidden.bs.modal', function() {
    time = 5;
    clearTimeout(timer);
  });
});
