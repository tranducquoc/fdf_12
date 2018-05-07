module Ads::PostsHelper
  def parent_category_id_of post
    post.category ? post.category.parent_category.id : ""
  end

  def child_category_id_of post
    post.category ? post.category.id : ""
  end

  def format_price post_price
    return unless post_price
    post_price.to_i == post_price ? post_price.to_i : post_price
  end
end
