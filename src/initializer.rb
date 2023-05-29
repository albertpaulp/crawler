# frozen_string_literal: true
# typed: true

require 'benchmark'
require 'concurrent'
require 'net/http'
require 'nokogiri'
require 'pry'
require 'sorbet-runtime'
require 'uri'
require 'zeitwerk'

loader = Zeitwerk::Loader.new
loader.push_dir('src/service/')
loader.setup
