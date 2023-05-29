# frozen_string_literal: true
# typed: true

# service class to fetch, parse and extract URLs from a URL
class UrlExtractor
  extend T::Sig
  ALLOWED_DOMAIN = 'monzo.com'

  def initialize(url:)
    @url = url
  end

  def call
    response_body = request_body

    all_urls = Nokogiri::HTML(response_body).css('a').map { |link| link['href'] }
    all_urls.map do |url|
      parsed = URI.parse(url)
      parsed.host == ALLOWED_DOMAIN ? parsed : nil
    rescue URI::InvalidURIError
      nil
    end.compact.uniq
  end

  private

  def request_body
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true
    path = @url.path.empty? ? '/' : @url.path
    http.get(path).body
  end
end
