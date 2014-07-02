class AddRelatedToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :related, :text
  end
end
