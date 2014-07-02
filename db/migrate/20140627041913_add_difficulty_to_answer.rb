class AddDifficultyToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :difficulty, :string
  end
end
