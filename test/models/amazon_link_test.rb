require "test_helper"

class AmazonLinkTest < ActiveSupport::TestCase
  test "resolves amzn.to short URL to amazon.com on save" do
    amazon_link = AmazonLink.new(summary: summaries(:one), url: "https://amzn.to/2GlSvyy")
    amazon_link.save

    assert_includes amazon_link.url, "amazon.com"
    assert_not_includes amazon_link.url, "amzn.to"
  end
end
