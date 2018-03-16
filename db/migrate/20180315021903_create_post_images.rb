class CreatePostImages < ActiveRecord::Migration[5.0]
  def change
    create_table :post_images do |t|
      t.integer :post_id, foreign_key: true
      t.string :image

      t.timestamps
    end
  end
end
