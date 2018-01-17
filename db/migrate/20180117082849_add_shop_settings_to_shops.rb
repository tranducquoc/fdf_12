class AddShopSettingsToShops < ActiveRecord::Migration[5.0]
  def change
    add_column :shops, :shop_settings, :text
  end
end
