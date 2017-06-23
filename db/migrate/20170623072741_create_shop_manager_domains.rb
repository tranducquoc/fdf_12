class CreateShopManagerDomains < ActiveRecord::Migration[5.0]
  def change
    create_table :shop_manager_domains do |t|
      t.references :shop_manager, foreign_key: true
      t.references :domain, foreign_key: true

      t.timestamps
    end
  end
end
