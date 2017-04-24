class AddStatusOnOffToShops < ActiveRecord::Migration[5.0]
  def change
    add_column :shops, :status_on_off, :integer, default: 0
  end
end
