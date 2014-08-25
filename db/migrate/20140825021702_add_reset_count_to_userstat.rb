class AddResetCountToUserstat < ActiveRecord::Migration
  def change
    add_column :userstats, :resetCount, :integer
  end
end
