class CreateInvitations < ActiveRecord::Migration
  def up
    create_table :invitations do |t|
      t.string :friend_name, :friend_email, :message, :token
      t.integer :inviter_id
      t.timestamps
    end
  end

  def down
    drop_table :invitations
  end
end
