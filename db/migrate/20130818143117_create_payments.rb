class CreatePayments < ActiveRecord::Migration
  def up
    create_table :payments do |t|
      t.integer :user_id, :amount
      t.string :reference_id
    end
  end

  def down
    drop_table :payments
  end
end
