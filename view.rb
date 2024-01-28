class View
  def display_recipes(recipes)
    recipes.each_with_index do |recipe, index|
      puts "#{index + 1}- #{recipe.name} / #{recipe.description}"
    end
  end

  def ask_for(something)
    puts "What is the #{something} of your recipe?"
    gets.chomp
  end

  def ask_for_recipe
    puts "Which recipe would you like to update? (give a number)"
    gets.chomp.to_i
  end

  def search
    puts "Enter a keyword for recipes"
    gets.chomp
  end
end
