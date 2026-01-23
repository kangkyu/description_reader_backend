class Api::AmazonLinksController < Api::ApplicationController
  def index
    # Eager load user's summaries indexed by video_id
    @summaries_by_video_id = Current.session.user.summaries.index_by(&:video_id)
    user_video_ids = @summaries_by_video_id.keys

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
        summary = @summaries_by_video_id[video.id]
        {
          id: video.id,
          youtube_id: video.youtube_id,
          title: video.title,
          url: video.url,
          summary_text: summary&.summary_text
        }
      end
    }
  end
end
