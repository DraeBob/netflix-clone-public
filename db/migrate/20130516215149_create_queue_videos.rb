class CreateQueueVideos < ActiveRecord::Migration
  def up
    create_table :queue_videos do |t|
      t.integer :user_id, :video_id
      t.timestamps
    end
  end

  def down
    drop_table :queue_videos
  end
end
