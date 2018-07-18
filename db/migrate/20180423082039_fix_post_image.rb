class FixPostImage < ActiveRecord::Migration[5.0]
  def change
    add_column :post_images, :image_id, :integer, foreign_key: true
    remove_column :post_images, :image
  end
end
