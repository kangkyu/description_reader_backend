class CreateVideos < ActiveRecord::Migration[8.1]
  def change
    create_table :videos do |t|
      t.string :youtube_id
      t.string :title
      t.string :url

      t.timestamps
    end
    add_index :videos, :youtube_id, unique: true
  end
end
