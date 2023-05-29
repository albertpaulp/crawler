# frozen_string_literal: true

require './spec/spec_helper'

describe Crawler do
  before do
    @starting_url = URI.parse('https://monzo.com')
    @visited = Concurrent::Set.new
    @executor = double('executor')
    @crawler = Crawler.new(url: @starting_url, visited: @visited, executor: @executor, host: @starting_url.host)
    allow(@crawler).to receive(:extracted_urls).and_return([URI.parse('https://monzo.com/careers')])
  end

  describe '#call' do
    it 'adds url to visited' do
      allow(@executor).to receive(:post)

      expect { @crawler.call }.to change { @visited.count }.by(1)
      expect(@visited).to include(@starting_url)
    end

    it 'schedules crawling on new thread for new url' do
      expect(@executor).to receive(:post).once

      @crawler.call
    end
  end
end
