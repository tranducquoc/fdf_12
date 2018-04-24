class AddMaxMinPriceToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :min_price, :float
    add_column :posts, :max_price, :float
  end
end
