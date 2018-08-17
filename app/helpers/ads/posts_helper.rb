module Ads::PostsHelper
  def parent_category_id_of post
    post.category ? post.category.parent_category.id : ""
  end

  def child_category_id_of post
    post.category ? post.category_id : ""
  end

  def format_post_price post
    return format_price post.min_price if post.min_price == post.max_price
    "#{format_price post.min_price} - #{format_price post.max_price}"
  end

  def round_post_price price
    return price.to_i if price == price.to_i
    price
  end

  def format_post_domain post
    return post.domain_name if post.domain
    t "ads.post.arenas.professed"
  end

  def format_post_title title, max_size
    return title if title.size < max_size
    title[0..max_size] << "..."
  end

  def get_shops_active_by user
    user.shops.active
  end
end
