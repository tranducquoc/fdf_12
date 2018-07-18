$(document).ready(function(){
  $(document).on('change','.select-category select',function(){
    var domain_id = $(this).parent().data('domain-id');
    var category_level = $(this).parent().data('category-level');
    var selectedOption = this.selectedIndex;
    $.ajax({
      url: '/domains/'+ domain_id +'/ads/posts/new',
      type: 'GET',
      data: {category_id: $(this).val()},
      dataType: 'JSON',
      success: function(response) {
        if(response.children_categories.length > 0 && selectedOption != 0){
          var selectTag = '<div class="col-md-4 col-md-offset-4 select-category-children '
            +'select-category level-' + category_level
            + '" data-domain-id="' + domain_id
            + '" data-category-level="' + (category_level + 1) + '">'
            + '<select class="form-control parent-id-' + (category_level+1)
            + '" name="post[category_id]" id="post_category_id"></select>'
            + '</div>';
          var extendTag = '<div id="cate-extend-' + (category_level+1)
            + '" class="form-group row display-baseline"></div>';
          var parentSelected = $('.parent-id-'+category_level).val();
          $('.parent-id-'+category_level).attr('id','post_category');
          $('#cate-extend-'+category_level).html('');
          $('#cate-extend-'+category_level).append(selectTag);
          $('.select-category-children.level-' + category_level + ' select').html('');
          $('.select-category-children.level-' + category_level + ' select')
            .append('<option value="' + parentSelected + '">' + I18n.t("common.select_sub_category") + '</option>');
          $.each(response.children_categories, function(index, value) {
            $('.select-category-children.level-' + category_level + ' select')
              .append('<option value="' + value.id + '">' + value.name + '</option>');
          });
          $('#cate-extend-'+(category_level+1)).remove();
          $('#extend').append(extendTag);
        } else {
          $('#cate-extend-'+category_level).html('');
          $('.parent-id-'+category_level).attr('id','post_category_id');
        }
      }
    });
  });

  $(document).on('click', '#like', function() {
    $(this).parents('form').submit();
  });

  $(document).on('click', '#submit-review', function(event) {
    if ($('#ads-review').val().length > 255) {
      event.preventDefault();
      swal(I18n.t("ads.post.review.too_long", {number: 255}), '', 'error');
    } else if ($('#ads-review').val().length <= 0) {
      event.preventDefault();
      swal(I18n.t("ads.post.review.fail"), '', 'error');
    }
  });

  $(document).on('click', '#destroy_post', function() {
    var url = $('#show_post_path').attr('href');

    swal({
      title: I18n.t('confirm'),
      type: 'warning',
      showCancelButton: true,
      confirmButtonText: I18n.t('submit'),
      cancelButtonText: I18n.t('cancel'),
      closeOnCancel: true
    }, function(confirmed) {
      if(confirmed) {
        $.ajax({
          url: url,
          type: 'DELETE',
          dataType: 'script'
        });
      }
    });
  });

  $(document).on('click', '#create_post', function() {
    var url = $('#new_post').attr('action');
    $(this).prop('disabled', true);

    $.ajax({
      url: url,
      type: 'POST',
      data: createPostData(),
      processData: false,
      contentType: false,
    });
  });

  $(document).on('click', '#update_post', function() {
    var url = $('.edit_post').attr('action');
    $(this).prop('disabled', true);

    $.ajax({
      url: url,
      type: 'PATCH',
      data: createPostData(),
      processData: false,
      contentType: false,
    });
  });

  function createPostData() {
    var title = $('#post-title').val();
    var content = $('#post_content').val();
    var categoryId = $('#post_category_id').children('option:selected').val();
    var mode = $('input[name="post[mode]"]:checked').val();
    var arena = $('input[name="post[arena]"]:checked').val();
    var linkShop = $('#post_link_shop').val();
    var minPrice = $('#post_min_price').val();
    var maxPrice = $('#post_max_price').val();
    var postData = new FormData();

    postData.append('post[title]', title);
    postData.append('post[content]', content);
    postData.append('post[category_id]', categoryId);
    postData.append('post[mode]', mode);
    postData.append('post[arena]', arena);
    postData.append('post[link_shop]', linkShop);
    postData.append('post[min_price]', minPrice);
    postData.append('post[max_price]', maxPrice);
    for (var i = 0, file; file = dynamicFiles[i]; i++) {
      postData.append('post[images_attributes][' + (deleted_images + existing_images + i) + '][image]', file);
    }

    if (existing_images == 0 && deleted_images == 0) {
      if (dynamicFiles.length == 0) {
        postData.append('post[images_attributes][0][image]', '');
      }
    }

    $('.deleted_images input').each(function(key, value) {
      postData.append(value.name, value.value);
    });

    $('.deleted_images + input').each(function(key, value) {
      postData.append(value.name, value.value);
    });
    return postData;
  }
});
