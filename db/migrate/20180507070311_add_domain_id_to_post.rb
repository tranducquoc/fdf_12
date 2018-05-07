class AddDomainIdToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :domain_id, :integer, foreign_key: true
  end
end
