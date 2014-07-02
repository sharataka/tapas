class CreatePracticeSessions < ActiveRecord::Migration
  def change
    create_table :practice_sessions do |t|
      t.string :question_pool
      t.string :subjects
      t.integer :number_of_questions
      t.integer :number_correct
      t.integer :number_incorrect
      t.integer :user_id

      t.timestamps
    end
  end
end
