# frozen_string_literal: true
# typed: true

# service class handles crawling
class Crawler
  def initialize(url:, visited:, executor:)
    @url = url
    @visited = visited
    @executor = executor
  end

  def call
    @visited.add(@url)
    log_execution

    extracted_urls.each do |new_url|
      puts "thread #{Thread.current.object_id}: Found #{new_url}"
      next if @visited.include?(new_url)

      @executor.post { Crawler.new(url: new_url, visited: @visited, executor: @executor).call }
    end
    puts "thread #{Thread.current.object_id}: ==================================="
  end

  private

  def extracted_urls
    @extracted_urls ||= UrlExtractor.new(url: @url).call
  end

  def log_execution
    puts "thread #{Thread.current.object_id}: ==================================="
    puts "thread #{Thread.current.object_id}: Crawling #{@url}"
    puts "thread #{Thread.current.object_id}: Found #{extracted_urls.count} URLs"
  end
end
