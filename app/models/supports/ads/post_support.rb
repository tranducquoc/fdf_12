class Supports::Ads::PostSupport
  def initialize post = nil, user = nil
    @post = post
    @user = user
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
