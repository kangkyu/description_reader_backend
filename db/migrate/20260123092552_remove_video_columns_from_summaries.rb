class RemoveVideoColumnsFromSummaries < ActiveRecord::Migration[8.1]
  def change
    remove_column :summaries, :video_title, :string
    remove_column :summaries, :video_url, :string
    remove_column :summaries, :youtube_video_id, :string
  end
end
