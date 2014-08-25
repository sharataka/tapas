class CreateLessonFeedbacks < ActiveRecord::Migration
  def change
    create_table :lesson_feedbacks do |t|
      t.integer :lesson_id
      t.string :feedback

      t.timestamps
    end
  end
end
