class AddTopicSlugToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :topic_slug, :string
  end
end
