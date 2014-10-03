class AddQuestionIdToPracticeSessions < ActiveRecord::Migration
  def change
    add_column :practice_sessions, :question_id, :integer
  end
end
