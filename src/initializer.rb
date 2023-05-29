# frozen_string_literal: true
# typed: true

# Load all dependencies
require 'benchmark'
require 'concurrent'
require 'net/http'
require 'nokogiri'
require 'pry'
require 'sorbet-runtime'
require 'uri'
require 'zeitwerk'

# Load all files in src/service
loader = Zeitwerk::Loader.new
loader.push_dir('src/service/')
loader.setup
