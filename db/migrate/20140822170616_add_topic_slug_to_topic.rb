class AddTopicSlugToTopic < ActiveRecord::Migration
  def change
    add_column :topics, :topic_slug, :string
  end
end
