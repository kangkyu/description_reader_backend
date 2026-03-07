class VideoAmazonLink < ApplicationRecord
  belongs_to :video
  belongs_to :amazon_link

  validates :amazon_link_id, uniqueness: { scope: :video_id }

  after_destroy :destroy_orphaned_amazon_link

  private

  def destroy_orphaned_amazon_link
    amazon_link.destroy if amazon_link.videos.empty?
  end
end
