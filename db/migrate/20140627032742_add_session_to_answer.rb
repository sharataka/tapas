class AddSessionToAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :practicesession_id, :integer
  end
end
