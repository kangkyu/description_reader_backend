class Channel < ApplicationRecord
  has_many :videos, dependent: :nullify

  validates :uuid, presence: true, uniqueness: true

  after_create :push_to_merch_app

  private

  def push_to_merch_app
    PushChannelJob.perform_later(id)
  end
end
