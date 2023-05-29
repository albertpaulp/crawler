# frozen_string_literal: true
# typed: true

require 'net/http'
require 'pry'
require 'sorbet-runtime'
require 'uri'
require 'zeitwerk'
require 'nokogiri'

loader = Zeitwerk::Loader.new
loader.push_dir('src/service/')
loader.setup

starting_url = URI.parse(ARGV[0])
