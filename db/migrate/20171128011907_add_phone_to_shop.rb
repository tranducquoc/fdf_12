class AddPhoneToShop < ActiveRecord::Migration[5.0]
  def change
    add_column :shops, :phone, :string
  end
end
