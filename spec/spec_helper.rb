# frozen_string_literal: true

require 'concurrent'
require 'net/http'
require 'nokogiri'
require 'pry'
require 'sorbet-runtime'
require 'zeitwerk'
require 'rspec/sorbet'

loader = Zeitwerk::Loader.new
loader.push_dir('src/service/')
loader.setup

RSpec::Sorbet.allow_doubles!
