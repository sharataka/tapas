class CreateUserUnderstandLessons < ActiveRecord::Migration
  def change
    create_table :user_understand_lessons do |t|
      t.integer :user_id
      t.integer :lesson_id

      t.timestamps
    end
  end
end
