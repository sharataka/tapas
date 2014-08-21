class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :lesson_id
      t.string :name
      t.integer :order

      t.timestamps
    end
  end
end
