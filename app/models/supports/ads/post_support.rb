class Supports::Ads::PostSupport
  def initialize post = nil, user = nil, params = nil
    @post = post
    @user = user
    @params = params
  end

  def all_parent_categories
    Category.is_parent
  end

  def filtered_param
    category_slug = @params[:category_slug] ? @params[:category_slug] : Category.is_parent.first.slug
    category = Category.find_by slug: category_slug
    mode = (@params[:mode] == Post.modes.keys[1]) ? Post.modes.keys[1] : Post.modes.keys[0]
    time = (@params[:time] == Settings.post.asc) ? Settings.post.asc : Settings.post.desc
    return {category: category, mode: mode, time: time}
  end

  def filtered_posts
    Post.filtered_by_mode_time_category(filtered_param[:mode],
      filtered_param[:time], filtered_param[:category].id)
      .page(@params[:page]).per Settings.common.posts_per_page
  end

  def post_of_user
    @user.posts.count
  end

  def reviews_of_post
    Review.reviews_by_post(@post.class.name, @post.id).newest
  end

  def branch_of_post
    @user.domains.first.name
  end
end
