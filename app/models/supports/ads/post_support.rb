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
    category_id = @params[:category_id] ? @params[:category_id] : Category.is_parent.first.id
    category = Category.find_by(id: category_id)
    mode = @params[:mode].to_i.zero? ? Post.modes.keys[0] : Post.modes.keys[1]
    time = (@params[:time] == Settings.post.asc) ? Settings.post.asc : Settings.post.desc
    return Hash[category: category, mode: mode, time: time]
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
