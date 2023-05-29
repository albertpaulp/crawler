# frozen_string_literal: true
# typed: true

# service class handles crawling
class Crawler
  def initialize(url:, visited:)
    @url = url
    @visited = visited
  end

  def call
    UrlExtractor.new(url: @url).call
  end
end
