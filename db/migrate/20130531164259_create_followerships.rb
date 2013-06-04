class CreateFollowerships < ActiveRecord::Migration
  def up
    create_table :followerships do |t|
      t.integer :follower_id, :followee_id
      t.timestamps
    end
  end

  def down
    drop_table :followerships
  end
end
