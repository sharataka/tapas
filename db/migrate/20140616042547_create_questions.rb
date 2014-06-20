class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :prompt
      t.string :image
      t.string :supplement
      t.string :title
      t.string :difficulty
      t.string :topic
      t.string :correct_response
      t.string :incorrect_one
      t.string :incorrect_two
      t.string :incorrect_three
      t.string :video_explanation
      t.text :text_explanation
      t.string :other_explanation

      t.timestamps
    end
  end
end
