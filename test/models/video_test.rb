require "test_helper"

class VideoTest < ActiveSupport::TestCase
  test "can belong to a channel" do
    channel = Channel.create!(uuid: "UC_test123")
    video = Video.create!(youtube_id: "vid_abc", channel: channel)

    assert_equal channel, video.reload.channel
  end

  test "channel is optional" do
    video = Video.new(youtube_id: "no_channel_456")

    assert_predicate video, :valid?
    assert_nil video.channel
  end
end
