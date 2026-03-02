class FetchChannelJob < ApplicationJob
  queue_as :default

  def perform(video_id)
    video = Video.find_by(id: video_id)
    return if video.nil? || video.channel_id.present?

    yt_video = Yt::Video.new(id: video.youtube_id)
    channel_uuid = yt_video.channel_id
    return if channel_uuid.blank?

    channel = Channel.find_or_create_by!(uuid: channel_uuid)
    video.update!(channel: channel)
  rescue Yt::Errors::NoItems, Yt::Errors::RequestError => e
    Rails.logger.warn("FetchChannelJob failed for video #{video_id}: #{e.message}")
  end
end
