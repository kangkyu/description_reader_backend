class Video < ApplicationRecord
  has_many :video_amazon_links, dependent: :destroy
  has_many :amazon_links, through: :video_amazon_links
  has_many :summaries, dependent: :nullify

  validates :youtube_id, presence: true, uniqueness: true
end
