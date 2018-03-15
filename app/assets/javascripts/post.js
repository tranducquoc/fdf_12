$(document).ready(function(){
  $(document).on('change','.select-category-parent select',function(){
    var domain_id = $(this).parent().data('domain-id');
    $.ajax({
      url: '/domains/'+ domain_id +'/ads/posts/new',
      type: 'GET',
      data: {category_id: $(this).val()},
      dataType: 'JSON',
      success: function(response) {
        $('.select-category-children select').html('');
        $.each(response.children_categories, function(index, value) {
          $('.select-category-children select').append('<option value="' + value.id + '">' + value.name + '</option>');
        });
      }
    });
  })
})
