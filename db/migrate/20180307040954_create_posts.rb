class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :category_id
      t.string :tilte
      t.text :content
      t.string :image
      t.string :link_shop
      t.integer :type
      t.integer :mode

      t.timestamps
    end
  end
end
