class AddDeletedAtToShopDomains < ActiveRecord::Migration[5.0]
  def change
    add_column :shop_domains, :deleted_at, :datetime
    add_index :shop_domains, :deleted_at
  end
end
