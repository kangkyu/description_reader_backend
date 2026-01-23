class CreateAmazonLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :amazon_links do |t|
      t.references :summary, null: false, foreign_key: true
      t.string :url

      t.timestamps
    end
  end
end
