class AddTopicToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :topic, :string
  end
end
