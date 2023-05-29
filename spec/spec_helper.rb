# frozen_string_literal: true

require 'zeitwerk'
require 'sorbet-runtime'
require 'pry'
require 'net/http'
require 'nokogiri'

loader = Zeitwerk::Loader.new
loader.push_dir('src/service/')
loader.setup
