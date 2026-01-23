require "net/http"

class Api::SummariesController < Api::ApplicationController
  def index
    @summaries = Current.session.user.summaries
      .includes(video: :amazon_links)
      .order(created_at: :desc)
    render json: @summaries.map { |s| summary_json(s) }
  end

  def create
    @video = Video.find_or_initialize_by(youtube_id: params[:video_id])
    @video.assign_attributes(video_params)

    @summary = Current.session.user.summaries.find_or_initialize_by(video: @video)
    @summary.assign_attributes(summary_params)

    ActiveRecord::Base.transaction do
      @video.save!
      @summary.save!
      add_amazon_links_to_video
    end

    render json: summary_json(@summary), status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  private

  def video_params
    { title: params[:video_title], url: params[:video_url] }
  end

  def summary_params
    params.permit(:summary_text)
  end

  def amazon_links_params
    params.fetch(:amazon_links_attributes, []).map { |link| link.permit(:url) }
  end

  def add_amazon_links_to_video
    amazon_links_params.each do |link_params|
      url = resolve_amazon_url(link_params[:url])
      next if url.blank?

      amazon_link = AmazonLink.find_or_create_by(url: url)

      # Remove from all other videos (keep only on the latest video)
      amazon_link.video_amazon_links.where.not(video: @video).destroy_all

      # Add to current video if not already there
      @video.amazon_links << amazon_link unless @video.amazon_links.include?(amazon_link)
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

  def summary_json(summary)
    {
      id: summary.id,
      video_id: summary.video&.youtube_id,
      video_title: summary.video&.title,
      video_url: summary.video&.url,
      summary_text: summary.summary_text,
      created_at: summary.created_at,
      updated_at: summary.updated_at,
      amazon_links: summary.video&.amazon_links&.map { |link| { id: link.id, url: link.url } } || []
    }
  end
end
