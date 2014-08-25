class AddTopicUserfacingNameToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :topic_userfacing_name, :string
  end
end
