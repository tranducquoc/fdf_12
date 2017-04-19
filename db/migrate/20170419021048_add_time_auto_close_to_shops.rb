class AddTimeAutoCloseToShops < ActiveRecord::Migration[5.0]
  def change
    add_column :shops, :time_auto_close, :time, default: "01:00:00"
  end
end
