require "net/http"
require "json"

class PushChannelJob < ApplicationJob
  queue_as :default

  def perform(channel_id)
    channel = Channel.find_by(id: channel_id)
    return if channel.nil?

    api_url = ENV["MERCH_API_URL"]
    api_token = ENV["MERCH_API_TOKEN"]
    return if api_url.blank? || api_token.blank?

    uri = URI.join(api_url, "/api/v1/influencers")
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{api_token}"
    request["Content-Type"] = "application/json"
    request.body = { influencer: { handle: channel.uuid, platform: "YouTube", name: channel.uuid } }.to_json

    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https", open_timeout: 5, read_timeout: 5) do |http|
      http.request(request)
    end
  rescue StandardError => e
    Rails.logger.warn("PushChannelJob failed for channel #{channel_id}: #{e.message}")
  end
end
