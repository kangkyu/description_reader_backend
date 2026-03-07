class Channel < ApplicationRecord
  has_many :videos, dependent: :nullify
  has_many :amazon_links, through: :videos

  validates :uuid, presence: true, uniqueness: true
end
