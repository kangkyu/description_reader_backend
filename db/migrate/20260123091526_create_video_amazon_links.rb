class CreateVideoAmazonLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :video_amazon_links do |t|
      t.references :video, null: false, foreign_key: true
      t.references :amazon_link, null: false, foreign_key: true

      t.timestamps
    end
    add_index :video_amazon_links, [:video_id, :amazon_link_id], unique: true
  end
end
