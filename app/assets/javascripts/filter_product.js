$(document).ready(function () {
  var from = 0;
  var to = 0;
  $('#example_id').ionRangeSlider({
    type: 'double',
    grid: true,
    step: 1000,
    min: 0,
    max: 100000,
    from: 0,
    to: 100000,
    prettify_separator: '.',
    postfix: ' VND',
    onStart: function (data) {
      from = data.from
      to = data.to
    },
    onFinish: function (data) {
      from = data.from
      to = data.to
      get_product();
    }
  });

  $('#category_id').on('change', function() {
    get_product();
  });

  $('#price_sort').on('change', function() {
    get_product();
  });

  function get_product() {
    domain_id = $('#domain_id').val();
    category_id = $('#category_id').val();
    sort = $('#price_sort').val();
     $.ajax({
      url: '/domains/' + domain_id + '/products',
      type: 'GET',
      data: {
        from: from,
        to: to,
        category: category_id,
        price_sort: sort,
        page: 1
      }
    });
  }
});
