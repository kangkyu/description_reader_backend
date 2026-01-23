class AddVideoToSummaries < ActiveRecord::Migration[8.1]
  def change
    # Rename existing video_id (YouTube ID string) to avoid conflict
    rename_column :summaries, :video_id, :youtube_video_id

    # Remove the old unique index and add new one with renamed column
    remove_index :summaries, [:user_id, :youtube_video_id], if_exists: true

    # Add reference to videos table
    add_reference :summaries, :video, foreign_key: true

    # Add unique index on user_id and video_id (foreign key)
    add_index :summaries, [:user_id, :video_id], unique: true
  end
end
