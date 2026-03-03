require "net/http"

class AmazonLink < ApplicationRecord
  has_many :video_amazon_links, dependent: :destroy
  has_many :videos, through: :video_amazon_links

  validates :url, presence: true, uniqueness: true

  before_save :resolve_short_url

  private

  def resolve_short_url
    return unless url&.include?("amzn.to")

    uri = URI.parse(url)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: 5, read_timeout: 5) do |http|
      http.head(uri.path)
    end

    self.url = response["location"] if response["location"]
  rescue StandardError
    # Keep original URL if redirect resolution fails
  end
end
