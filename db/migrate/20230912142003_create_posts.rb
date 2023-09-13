class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :user_id, null: false
      t.string :title, null: false
      t.string :sauna_name, null: false
      t.string :address, null: false
      t.text :caption, null: false
      t.integer :status, default: 0, null: false
      t.timestamps
    end
  end
end
