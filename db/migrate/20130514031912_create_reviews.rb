class CreateReviews < ActiveRecord::Migration
  def up
    create_table :reviews do |t|
      t.integer :user_id, :video_id, :rate
      t.string :body
      t.timestamps
    end
  end

  def down
    drop_table :reviews
  end
end
