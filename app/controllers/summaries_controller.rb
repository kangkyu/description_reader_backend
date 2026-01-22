class SummariesController < ApplicationController
  def index
    @summaries = Current.session.user.summaries.order(created_at: :desc)
    render json: @summaries
  end

  def create
    @summary = Current.session.user.summaries.build(summary_params)
    if @summary.save
      render json: @summary, status: :created
    else
      render json: { errors: @summary.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def summary_params
    params.permit(:video_id, :video_title, :summary_text, :video_url)
  end
end
