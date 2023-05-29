# frozen_string_literal: true

require './spec/spec_helper'

describe UrlExtractor do
  describe '#call' do
    before do
      # mock the http request
      mock_body = '<html><body><a href="https://monzo.com/support">Monzo Support</a></body></html>'
      mocked_http = double('http', 'use_ssl='.to_sym => true, get: instance_double('response', body: mock_body))
      allow(Net::HTTP).to receive(:new).and_return(mocked_http)
    end

    it 'return list of urls found in passed in URL' do
      response = UrlExtractor.new(url: URI.parse('https://monzo.com'), host: 'monzo.com').call

      expect(response).to eq([URI.parse('https://monzo.com/support')])
    end

    it 'does not return urls that are not on different host' do
      response = UrlExtractor.new(url: URI.parse('https://monzo.com'), host: 'google.com').call

      expect(response).to eq([])
    end
  end
end
