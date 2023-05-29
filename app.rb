# frozen_string_literal: true
# typed: true

require './src/initializer'

# Using thread-safe Set instead of Array to avoid duplicates and faster lookup
visited = Concurrent::Set.new

# Using a thread pool to limit the number of threads
executor = Concurrent::ThreadPoolExecutor.new(
  min_threads: 1,
  max_threads: Concurrent.processor_count,
  max_queue: 100,
  fallback_policy: :caller_runs
)

# Add validation for the URL if needed.
# For now, assuming that the URL is valid. eg. https://www.monzo.com
starting_url = URI.parse(ARGV[0])

benchmark = Benchmark.measure do
  Crawler.new(
    host: T.must(starting_url.host),
    url: starting_url,
    visited:,
    executor:
  ).call

  # Wait for all threads to finish
  executor.shutdown
  executor.wait_for_termination
end

puts "Completed crawling in #{benchmark.real} seconds, found #{visited.count} unique URLs"
visited.each_with_index do |url, index|
  puts "#{index}. #{url}"
end
