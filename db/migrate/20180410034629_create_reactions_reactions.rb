class CreateReactionsReactions < ActiveRecord::Migration[5.0]
  def change
    create_table :reactions do |t|
      t.integer :amount
      t.references :user, foreign_key: true
      t.references :reactionable, polymorphic: true
      t.string :type

      t.timestamps
    end
  end
end
