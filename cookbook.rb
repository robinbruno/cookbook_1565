require "csv"
require_relative "recipe"

class Cookbook
  def initialize
    @recipes = []
    @csv_file_path = "./recipes.csv"
    load_csv
  end

  def all
    @recipes
  end

  def find(id)
    @recipes[id]
  end

  def add(recipe)
    @recipes << recipe
    save_csv
  end

  def update
    save_csv
  end

  def remove(id)
    @recipes.delete_at(id)
    save_csv
  end

  # OPTIONAL: storing results from search into CSV

  def store(response)
    @recipes += response
    save_csv
  end

  private

  def load_csv
    CSV.foreach(@csv_file_path, headers: :first_row) do |row|
      row["id"] = row["id"].to_i
      recipe = Recipe.new(row["name"], row["description"])
      @recipes << recipe
    end
  end

  def save_csv
    CSV.open(@csv_file_path, "wb") do |csv|
      csv << ["name", "description"]
      @recipes.each do |recipe|
        csv << [recipe.name, recipe.description]
      end
    end
  end
end
