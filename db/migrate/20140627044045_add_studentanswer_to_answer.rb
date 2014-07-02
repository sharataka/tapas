class AddStudentanswerToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :studentanswer, :string
  end
end
