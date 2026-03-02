class CreateChannels < ActiveRecord::Migration[8.1]
  def change
    create_table :channels do |t|
      t.string :uuid

      t.timestamps
    end
    add_index :channels, :uuid, unique: true
  end
end
