class Video < ApplicationRecord
  belongs_to :channel, optional: true

  has_many :video_amazon_links, dependent: :destroy
  has_many :amazon_links, through: :video_amazon_links
  has_many :summaries, dependent: :nullify

  validates :youtube_id, presence: true, uniqueness: true

  after_save :enqueue_channel_lookup, if: -> { channel_id.nil? && youtube_id.present? }

  private

  def enqueue_channel_lookup
    FetchChannelJob.perform_later(id)
  end
end
