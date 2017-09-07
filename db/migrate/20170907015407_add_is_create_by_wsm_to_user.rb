class AddIsCreateByWsmToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_create_by_wsm, :boolean, default: false
  end
end
