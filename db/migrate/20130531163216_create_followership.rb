class CreateFollowership < ActiveRecord::Migration
  def up
    create_table :followership do |t|
      t.integer :user_id, :follower_id
      t.timestamps
    end
  end

  def down
    drop_table :followership
  end
end
