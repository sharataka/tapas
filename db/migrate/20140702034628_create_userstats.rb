class CreateUserstats < ActiveRecord::Migration
  def change
    create_table :userstats do |t|
      t.string :permissions
      t.integer :user_id

      t.timestamps
    end
  end
end
