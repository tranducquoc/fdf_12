class AddDomainDefaultToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :domain_default, :int
  end
end
