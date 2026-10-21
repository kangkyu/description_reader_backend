require "net/http"

class FetchChannelJob < ApplicationJob
  queue_as :default

  def perform(video_id, amazon_link_urls = [])
    video = Video.find_by(id: video_id)
    return if video.nil?

    add_amazon_links_to_video(video, amazon_link_urls)

    return if video.channel_id.present?

    yt_video = Yt::Video.new(id: video.youtube_id)
    channel_uuid = yt_video.channel_id
    return if channel_uuid.blank?

    yt_channel = Yt::Channel.new(id: channel_uuid)

    channel = Channel.find_or_initialize_by(uuid: channel_uuid)
    new_channel = channel.new_record?
    channel.title ||= yt_channel.title
    channel.handle ||= yt_channel.custom_url
    channel.save!
    video.update!(channel: channel)

  rescue Yt::Errors::NoItems, Yt::Errors::RequestError => e
    Rails.logger.warn("FetchChannelJob failed for video #{video_id}: #{e.message}")
  end

  private

  def add_amazon_links_to_video(video, urls)
    urls.each do |url|
      resolved_url = resolve_amazon_url(url)
      next if resolved_url.blank?

      amazon_link = AmazonLink.find_or_initialize_by(url: resolved_url)
      amazon_link.save!

      video.amazon_links << amazon_link unless video.amazon_links.include?(amazon_link)
    end
  end

  def resolve_amazon_url(url)
    return url unless url&.include?("amzn.to")

    uri = URI.parse(url)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 5) do |http|
      http.head(uri.path)
    end
    response["location"] || url
  rescue StandardError
    url
  end
end
