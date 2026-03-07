class AddTitleAndHandleToChannels < ActiveRecord::Migration[8.1]
  def change
    add_column :channels, :title, :string
    add_column :channels, :handle, :string
  end
end
