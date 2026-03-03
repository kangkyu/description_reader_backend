class Channel < ApplicationRecord
  has_many :videos, dependent: :nullify

  validates :uuid, presence: true, uniqueness: true
end
