class VideoAmazonLink < ApplicationRecord
  belongs_to :video
  belongs_to :amazon_link

  validates :amazon_link_id, uniqueness: { scope: :video_id }
end
