class CreateVideoCategories < ActiveRecord::Migration
  def up
    create_table :video_categories do |t|
      t.integer :video_id, :category_id
      t.timestamps
    end
  end

  def down
    drop_table :video_categories
  end
end
