class Api::ChannelsController < Api::ApplicationController
  allow_unauthenticated_access

  def index
    amazon_links = AmazonLink.includes(videos: :channel).all

    render json: amazon_links.map { |link|
      channels = link.videos.filter_map(&:channel).uniq(&:id)
      {
        url: link.url,
        channels: channels.map { |c| { uuid: c.uuid, title: c.title, handle: c.handle } }
      }
    }
  end
end
