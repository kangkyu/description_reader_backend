class RemoveSummaryIdFromAmazonLinks < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :amazon_links, :summaries
    remove_column :amazon_links, :summary_id, :bigint
  end
end
