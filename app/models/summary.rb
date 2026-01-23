class Summary < ApplicationRecord
  belongs_to :user
  belongs_to :video, optional: true

  validates :video_id, uniqueness: { scope: :user_id }, allow_nil: true

  # Delegate amazon_links to video for convenience
  delegate :amazon_links, to: :video, allow_nil: true
end
