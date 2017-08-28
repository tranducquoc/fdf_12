class AddRoomChatworkToDomain < ActiveRecord::Migration[5.0]
  def change
    add_column :domains, :room_chatwork, :string
  end
end
