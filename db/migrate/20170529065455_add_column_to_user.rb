class AddColumnToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :email_settings, :text
    add_column :users, :notification_settings, :text
    add_column :users, :language, :string
  end
end
