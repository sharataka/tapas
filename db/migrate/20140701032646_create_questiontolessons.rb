class CreateQuestiontolessons < ActiveRecord::Migration
  def change
    create_table :questiontolessons do |t|
      t.integer :lesson_id
      t.integer :question_id

      t.timestamps
    end
  end
end
