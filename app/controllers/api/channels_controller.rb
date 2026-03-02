class Api::ChannelsController < Api::ApplicationController
  allow_unauthenticated_access

  def index
    amazon_links = AmazonLink.includes(videos: :channel).all

    render json: amazon_links.map { |link|
      channel_uuids = link.videos.filter_map { |v| v.channel&.uuid }.uniq
      { url: link.url, channel_uuids: channel_uuids }
    }
  end
end
