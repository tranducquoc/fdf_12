class AddDeletedAtToDomains < ActiveRecord::Migration[5.0]
  def change
    add_column :domains, :deleted_at, :datetime
    add_index :domains, :deleted_at
  end
end
