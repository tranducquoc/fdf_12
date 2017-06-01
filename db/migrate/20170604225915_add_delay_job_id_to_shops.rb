class AddDelayJobIdToShops < ActiveRecord::Migration[5.0]
  def change
    add_column :shops, :delayjob_id, :integer
  end
end
