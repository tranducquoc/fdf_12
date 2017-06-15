class AddDeletedAtToUserDomains < ActiveRecord::Migration[5.0]
  def change
    add_column :user_domains, :deleted_at, :datetime
    add_index :user_domains, :deleted_at
  end
end
