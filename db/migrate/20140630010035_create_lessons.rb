class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :title
      t.string :length
      t.string :url
      t.string :platform
      t.string :thumbnail
      t.string :nextlesson
      t.string :topic
      t.integer :order

      t.timestamps
    end
  end
end
