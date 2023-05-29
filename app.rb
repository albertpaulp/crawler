# frozen_string_literal: true
# typed: true

require './src/initializer'

# Using Set instead of Array to avoid duplicates and faster lookup
visited = Concurrent::Set.new

# Using a thread pool to limit the number of threads
executor = Concurrent::ThreadPoolExecutor.new(
  min_threads: 1,
  max_threads: Concurrent.processor_count,
  max_queue: 100,
  fallback_policy: :caller_runs
)

starting_url = URI.parse(ARGV[0])

Crawler.new(url: starting_url, visited:, executor:).call

executor.shutdown
executor.wait_for_termination

puts "Completed crawling, found #{visited.count} unique URLs"
visited.each do |url|
  puts url
end
