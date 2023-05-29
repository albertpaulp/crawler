# frozen_string_literal: true
# typed: true

# service class handles crawling a URL and schedules new URLs for crawling in threads
class Crawler
  extend T::Sig

  sig do
    params(host: String, url: URI::Generic, visited: Concurrent::Set, executor: Concurrent::ThreadPoolExecutor).void
  end
  def initialize(host:, url:, visited:, executor:)
    @url = url
    @visited = visited
    @executor = executor
    @host = host
  end

  sig { void }
  def call
    @visited.add(@url)
    log_execution

    extracted_urls.each do |new_url|
      puts "thread #{Thread.current.object_id}: Found #{new_url}"
      next if @visited.include?(new_url)

      # Ask the executor to crawl new url on a new thread
      @executor.post { Crawler.new(host: @host, url: new_url, visited: @visited, executor: @executor).call }
    end
    puts "thread #{Thread.current.object_id}: ==================================="
  end

  private

  sig { returns(T::Array[URI::Generic]) }
  def extracted_urls
    @extracted_urls ||= UrlExtractor.new(url: @url, host: @host).call
  end

  sig { void }
  def log_execution
    puts "thread #{Thread.current.object_id}: ==================================="
    puts "thread #{Thread.current.object_id}: Crawling #{@url}"
    puts "thread #{Thread.current.object_id}: Found #{extracted_urls.count} URLs"
  end
end
