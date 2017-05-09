class Supports::SearchSupport
  def initialize shop_id, user_ids, key_word
    @shop_id = shop_id
    @user_ids = user_ids
    @key_word = key_word
  end

  def shops_managers
    ShopManager.all
  end

  def shop_manager
    ShopManager.find_by shop_id: @shop_id
  end

  def users
    User.user_of_list_id(@user_ids).search(name_cont: @key_word.strip).result
  end
end
