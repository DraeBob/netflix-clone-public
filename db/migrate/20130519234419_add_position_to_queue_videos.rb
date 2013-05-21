class AddPositionToQueueVideos < ActiveRecord::Migration
  def change
    add_column :queue_videos, :position, :integer
  end
end
