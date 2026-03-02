class AddChannelToVideos < ActiveRecord::Migration[8.1]
  def change
    add_reference :videos, :channel, null: true, foreign_key: true
  end
end
