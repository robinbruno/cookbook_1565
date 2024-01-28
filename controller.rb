require_relative "view"
require_relative "recipe"
require_relative "scraping"
require "pry"

class Controller
  def initialize(repository)
    @repo = repository
    @view = View.new
  end

  def list
    display_recipes
  end

  def create
    name = @view.ask_for("name")
    description = @view.ask_for("description")
    recipe = Recipe.new(name, description)
    @repo.add(recipe)
  end

  def update
    display_recipes
    recipe_id = @view.ask_for_recipe - 1
    recipe = @repo.find(recipe_id)
    recipe.name = @view.ask_for("name")
    recipe.description = @view.ask_for("description")
    @repo.update
  end

  def destroy
    display_recipes
    recipe_id = @view.ask_for_recipe - 1
    @repo.remove(recipe_id)
  end

  def search
    search = @view.search
    response = ScrapingTool.new(search).call
    @view.display_recipes(response)
    # OPTIONAL: storing results from search into CSV
    @repo.store(response)
  end

  private

  def display_recipes
    recipes = @repo.all
    @view.display_recipes(recipes)
  end
end
