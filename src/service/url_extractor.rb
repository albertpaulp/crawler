# frozen_string_literal: true
# typed: true

# service class to fetch, parse and extract URLs from a URL
class UrlExtractor
  extend T::Sig

  sig { params(url: URI, host: String).void }
  def initialize(url:, host:)
    @url = url
    @host = host
  end

  sig { returns(T::Array[URI]) }
  def call
    response_body = request_body

    all_urls = Nokogiri::HTML(response_body).css('a').map { |link| link['href'] }
    all_urls.map do |url|
      parsed = URI.parse(url)
      parsed.host == @host ? parsed : nil
    rescue URI::InvalidURIError
      nil
    end.compact.uniq
  end

  private

  sig { returns(String) }
  def request_body
    http = Net::HTTP.new(@url.host, @url.port)
    http.use_ssl = true
    path = @url.path.empty? ? '/' : @url.path
    http.get(path).body
  end
end
