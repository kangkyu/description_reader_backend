class Api::AmazonLinksController < Api::ApplicationController
  def index
    # Get all amazon_links that belong to videos the user has summaries for
    user_video_ids = Current.session.user.summaries.pluck(:video_id)

    @amazon_links = AmazonLink
      .joins(:videos)
      .where(videos: { id: user_video_ids })
      .distinct
      .includes(:videos)
      .order(created_at: :desc)

    render json: @amazon_links.map { |link| amazon_link_json(link, user_video_ids) }
  end

  private

  def amazon_link_json(amazon_link, user_video_ids)
    {
      id: amazon_link.id,
      url: amazon_link.url,
      created_at: amazon_link.created_at,
      videos: amazon_link.videos.where(id: user_video_ids).map do |video|
        {
          id: video.id,
          youtube_id: video.youtube_id,
          title: video.title,
          url: video.url
        }
      end
    }
  end
end
