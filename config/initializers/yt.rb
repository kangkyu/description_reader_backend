require "yt"

class Yt::Models::Snippet
  has_attribute :custom_url, default: ''
end

class Yt::Models::Channel
  delegate :custom_url, to: :snippet
end
