class MigrateExistingVideoData < ActiveRecord::Migration[8.1]
  def up
    # Create Video records from existing summaries (using renamed youtube_video_id column)
    execute <<-SQL
      INSERT INTO videos (youtube_id, title, url, created_at, updated_at)
      SELECT DISTINCT ON (youtube_video_id) youtube_video_id, video_title, video_url, created_at, updated_at
      FROM summaries
      WHERE youtube_video_id IS NOT NULL
      ORDER BY youtube_video_id, created_at DESC
    SQL

    # Update summaries to reference the new Video records
    execute <<-SQL
      UPDATE summaries
      SET video_id = videos.id
      FROM videos
      WHERE summaries.youtube_video_id = videos.youtube_id
    SQL

    # Create VideoAmazonLink records from existing amazon_links
    execute <<-SQL
      INSERT INTO video_amazon_links (video_id, amazon_link_id, created_at, updated_at)
      SELECT DISTINCT v.id, al.id, al.created_at, al.updated_at
      FROM amazon_links al
      JOIN summaries s ON s.id = al.summary_id
      JOIN videos v ON v.youtube_id = s.youtube_video_id
    SQL
  end

  def down
    execute "DELETE FROM video_amazon_links"
    execute "UPDATE summaries SET video_id = NULL"
    execute "DELETE FROM videos"
  end
end
