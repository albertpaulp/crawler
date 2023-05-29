# frozen_string_literal: true
# typed: true

require './src/initializer'

starting_url = URI.parse(ARGV[0])

puts Crawler.new(url: starting_url, visited: Set.new).call
