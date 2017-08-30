class AddTimeForeverToShops < ActiveRecord::Migration[5.0]
  def change
    add_column :shops, :time_open, :time, default: "00:00:00"
    add_column :shops, :time_close, :time, default: "00:00:00"
  end
end
