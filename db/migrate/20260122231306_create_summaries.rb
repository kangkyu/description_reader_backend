class CreateSummaries < ActiveRecord::Migration[8.1]
  def change
    create_table :summaries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :video_id
      t.string :video_title
      t.text :summary_text
      t.string :video_url

      t.timestamps
    end
  end
end
