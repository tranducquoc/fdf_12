class AddOpenForeverToShops < ActiveRecord::Migration[5.0]
  def change
    add_column :shops, :openforever, :boolean, default: false
  end
end
