# COOKBOOK LIVECODE

## LOAD CSV
- Create a CSV file **recipes.csv** and add the titles and a couple of rows
  ```csv
  name,description
  mushrooms,delicious
  pizza,lot's of cheese
  ```
- Call the **load_csv** method in the Initialize of the Repo, and remind that we need to **require 'csv'** at the top, and load the path
  ```ruby
    def initialize(csv_file_path)
      @recipes = []
      @csv_file_path = csv_file_path
      load_csv
    end
  ```
- Alternative way of loading CSV that creates an absolute path
  ```ruby
  csv_file = File.join(__dir__, "recipes.csv")
  ```
- Implement the **load_csv** method in a private section
  ```ruby
    def load_csv
      CSV.foreach(@csv_file_path, headers: :first_row) do |row|
        recipe = Recipe.new(row["name"], row["description"])
        @recipes << recipe
      end
    end
  ```

## STORE TO CSV
We need to save the CSV when we **add**, **update** or **delete** a recipe
- Uncomment the 3 **save_csv** in the 3 methods
- Implement the **save_csv** method in the private section
  ```ruby
  def save_csv
    CSV.open(@csv_file_path, "wb") do |csv|
      csv << ["name", "description"]
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description]
      end
    end
  end
  ```
- add `@repo.update` in the **update** method of the **CONTROLLER**
  ```ruby
  def update
    display_recipes
    recipe_id = @view.ask_for_recipe - 1
    recipe = @repo.find(recipe_id)
    recipe.name = @view.ask_for("name")
    recipe.description = @view.ask_for("description")
    @repo.update
  end
  ```

## SCRAPING
- Introduce students the website we will be scraping: https://www.allrecipes.com/search?q=strawberry
- Update the route in the router (`when 5 then @controller.search`)
- Controller:
  - Comment back the line `require_relative "scraping"` at the top
  - Implement the **search method** that contains 3 steps:
    1. Get Search word from user
    2. Scrape
    3. Display responses
    ```ruby
    def search
      search = @view.search
      response = ScrapingTool.new(search).call
      @view.display_recipes(response)
    end
    ```
- View: implement the `@view.search` method
  ```ruby
  def search
    puts "Enter a keyword for recipes"
    gets.chomp
  end
  ```
- Create the `scraping.rb` file and implement the **ScrapingTool** feature
  ```ruby
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
  ```
## Breaking down the code
- ```Nokogiri::HTML.parse(...)``` returns the parsed HTML document in a structured way. It provides a hierarchical structure that corresponds to the structure of the HTML document.
- `element.search("...").text` returns the text content of the targeted tag
- `element.atribute("...").value` returns the value of an attribute of the tag
  
## OPTIONAL: Store result of Search in CSV
- Call the function in the **search** method in the **controller**:
  ```ruby
  @repo.store(response)
  ```
- Add the **store** method in the **repo**:
  ```ruby
  def store(response)
    @recipes += response
    save_csv
  end
  ```
