class AddUniqueIndexToSummariesVideoId < ActiveRecord::Migration[8.1]
  def change
    add_index :summaries, [:user_id, :video_id], unique: true
  end
end
