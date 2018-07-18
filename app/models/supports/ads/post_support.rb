class Supports::Ads::PostSupport
  attr_reader :post, :params, :user, :parent_categories, :children_categories

  def initialize post = nil, user = nil, params = nil
    @post = post
    @user = user
    @params = params

    @parent_categories = Category.is_parent
    @children_categories = Category.by_parent @parent_categories.first.id
  end

  def parent_categories number=nil
    return Category.is_parent unless number
    Category.is_parent.last number
  end

  def all_categories
    Category.all
  end

  def featured_posts number=nil
    return Post.all.approved unless number
    Post.approved.last number
  end

  def filtered_param
    category_slug = params[:category_slug]
    category = Category.find_by slug: category_slug
    current_domain = Domain.friendly_id.find_by slug: params[:domain_id]
    mode = params[:mode]
    time = (params[:time] == Settings.post.asc) ? Settings.post.asc : Settings.post.desc
    type = params[:type] == Post.filters.keys[1] ? Post.filters.keys[1] : Post.filters.keys[0]
    {category: category, mode: mode, time: time, type: type, domain: current_domain,
      category_slug: category_slug}
  end

  def filtered_posts
    posts = Post.approved
    if filtered_param[:mode].present?
      posts = posts.filtered_by_mode(filtered_param[:mode])
    end
    if filtered_param[:category].present?
      posts = posts.filtered_by_category(filtered_param[:category].id)
    end
    if filtered_param[:type] == Post.filters.keys[0]
      posts = posts.filtered_by_time(filtered_param[:time])
        .by_domain(filtered_param[:domain].id)
        .page(params[:page]).per Settings.common.posts_per_page
    elsif filtered_param[:type] == Post.filters.keys[1]
      most_reviewed_post
    end
  end

  def post_of_user
    user.posts.count
  end

  def reviews_of_post
    Review.reviews_by_post(post.class.name, post.id).newest
  end

  def branch_of_post
    user.domains.first.name
  end

  def children_categories= value
    @children_categories = value
  end

  def find_shop
    Shop.find_by slug: @post.link_shop
  end

  def working_time format
    "#{shop.time_open.strftime format} - #{shop.time_close.strftime format}"
  end

  def most_reviewed_post per_page = Settings.common.posts_per_page
    case
    when filtered_param[:mode].present? && filtered_param[:category].present?
      Post.most_reviewed(filtered_param[:mode], filtered_param[:time], filtered_param[:category].id)
        .page(params[:page]).per per_page
    when filtered_param[:mode].present?
      Post.most_reviewed_by_mode(filtered_param[:mode], filtered_param[:time])
        .page(params[:page]).per per_page
    when filtered_param[:category].present?
      Post.most_reviewed_by_category(filtered_param[:category].id, filtered_param[:time])
        .page(params[:page]).per per_page
    else
      Post.most_reviewed_order_by_time(filtered_param[:time]).page(params[:page])
        .per per_page
    end
  end
end
