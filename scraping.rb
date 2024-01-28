require "nokogiri"
require "open-uri"
require_relative "recipe"

class ScrapingTool
  def initialize(search)
    @search = search
  end

  def call
    url = "https://www.allrecipes.com/search?q=#{@search}"
    response = Nokogiri::HTML.parse(URI.open(url))
    recipes = []

    response.search(".mntl-card-list-items.card").first(10).each do |element|
      name = element.search(".card__title-text").text
      details_url = element.attribute("href").value
      description_page = Nokogiri::HTML.parse(URI.open(details_url))
      description = description_page.search("#article-subheading_1-0").text
      recipes << Recipe.new(name, description)
    end
    recipes
  end
end
