class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :email, :fullname, :password_digest
      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
