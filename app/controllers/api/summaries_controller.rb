require "net/http"

class Api::SummariesController < Api::ApplicationController
  def index
    @summaries = Current.session.user.summaries.includes(:amazon_links).order(created_at: :desc)
    render json: @summaries.as_json(include: :amazon_links)
  end

  def create
    @summary = Current.session.user.summaries.find_or_initialize_by(video_id: params[:video_id])
    @summary.assign_attributes(summary_params.except(:amazon_links_attributes))
    if @summary.persisted?
      add_new_amazon_links
    else
      @summary.amazon_links.build(amazon_links_params)
    end
    if @summary.save
      render json: @summary.as_json(include: :amazon_links), status: :created
    else
      render json: { errors: @summary.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def summary_params
    params.permit(:video_id, :video_title, :summary_text, :video_url, amazon_links_attributes: [:url])
  end

  def amazon_links_params
    params.fetch(:amazon_links_attributes, []).map { |link| link.permit(:url) }
  end

  def add_new_amazon_links
    incoming_urls = amazon_links_params.map { |link| link[:url] }.compact
    resolved_urls = incoming_urls.map { |url| resolve_amazon_url(url) }
    existing_urls = @summary.amazon_links.pluck(:url)
    new_urls = resolved_urls - existing_urls
    new_urls.each { |url| @summary.amazon_links.build(url: url) }
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
