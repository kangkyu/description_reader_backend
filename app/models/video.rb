class Video < ApplicationRecord
  belongs_to :channel, optional: true

  has_many :video_amazon_links, dependent: :destroy
  has_many :amazon_links, through: :video_amazon_links
  has_many :summaries, dependent: :nullify

  validates :youtube_id, presence: true, uniqueness: true

  after_save :track_needs_channel_lookup
  after_commit :enqueue_channel_lookup

  private

  def track_needs_channel_lookup
    @needs_channel_lookup = channel_id.nil? && youtube_id.present?
  end

  def enqueue_channel_lookup
    FetchChannelJob.perform_later(id) if @needs_channel_lookup
  end
end
