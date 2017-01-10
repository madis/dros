require 'httparty'
require 'nokogiri'

# Requests & parses data from githube trends html page
class GithubTrending
  def self.today(language: '')
    new(period: 'today', language: language).find
  end

  def self.weekly(language: '')
    new(period: 'weekly', language: language).find
  end

  def self.monthly(language: '')
    new(period: 'monthly', language: language).find
  end

  def initialize(period:, language: '')
    @period = period
    @language = language
  end

  def find
    trending_html_rows.map do |row|
      {
        slug: slug(row),
        language: language(row),
        stars: stars(row),
        period: @period
      }
    end
  end

  private

  def trending_html_rows
    response = HTTParty.get "https://github.com/trending/#{@language}?since=#{@period}"
    xml_doc = Nokogiri::HTML(response.body)
    xml_doc.css '.repo-list li'
  end

  def slug(xml_row)
    xml_row.at_css('h3 a')['href'].sub(%r{^\/}, '')
  end

  def language(xml_row)
    element = xml_row.at_css('span[itemprop=programmingLanguage]')
    return if element.nil?
    element.text.strip.downcase if element
  end

  def stars(xml_row)
    element = xml_row.at_css('span.float-right')
    return 0 if element.nil?
    element.text.strip.split(' stars').first.to_i
  end
end
