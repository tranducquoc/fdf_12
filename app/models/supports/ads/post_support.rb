class Supports::Ads::PostSupport
  def initialize post = nil, user = nil
    @post = post
    @user = user
  end

  def post_of_user
    @user.posts.count
  end
end
