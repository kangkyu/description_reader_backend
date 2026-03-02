require "test_helper"

class ChannelTest < ActiveSupport::TestCase
  test "valid with uuid" do
    channel = Channel.new(uuid: "UC_test123")
    assert_predicate channel, :valid?
  end

  test "invalid without uuid" do
    channel = Channel.new
    assert_not channel.valid?
  end

  test "uuid must be unique" do
    Channel.create!(uuid: "UC_test123")
    duplicate = Channel.new(uuid: "UC_test123")
    assert_not duplicate.valid?
  end

  test "nullifies videos on destroy" do
    channel = Channel.create!(uuid: "UC_test123")
    video = Video.create!(youtube_id: "vid_abc", channel: channel)

    channel.destroy
    assert_nil video.reload.channel_id
  end
end
