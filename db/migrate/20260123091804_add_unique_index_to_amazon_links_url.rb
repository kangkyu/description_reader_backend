class AddUniqueIndexToAmazonLinksUrl < ActiveRecord::Migration[8.1]
  def up
    change_column_null :amazon_links, :summary_id, true

    # Remove duplicate URLs, keeping the oldest record
    execute <<-SQL
      DELETE FROM amazon_links
      WHERE id NOT IN (
        SELECT MIN(id)
        FROM amazon_links
        GROUP BY url
      )
    SQL

    add_index :amazon_links, :url, unique: true
  end

  def down
    remove_index :amazon_links, :url
    change_column_null :amazon_links, :summary_id, false
  end
end
