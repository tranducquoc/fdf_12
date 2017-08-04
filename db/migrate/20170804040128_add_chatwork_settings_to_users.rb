class AddChatworkSettingsToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :chatwork_settings, :text
  end
end
