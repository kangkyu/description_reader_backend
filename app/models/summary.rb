class Summary < ApplicationRecord
  belongs_to :user
  has_many :amazon_links, dependent: :destroy

  validates :video_id, presence: true, uniqueness: { scope: :user_id }

  accepts_nested_attributes_for :amazon_links
end
