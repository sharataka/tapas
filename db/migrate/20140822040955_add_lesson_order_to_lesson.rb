class AddLessonOrderToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :lesson_order, :integer
  end
end
