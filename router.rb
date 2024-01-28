class Router
  def initialize(controller)
    @controller = controller
    @running = true
  end

  def run
    while @running
      choice = list_choices
      user_choice(choice)
    end
  end

  private

  def list_choices
    puts "MENU\n"
    puts "----------------"
    puts "1- list recipes"
    puts "2- Add new recipe"
    puts "3- Update a recipe"
    puts "4- Delete a recipe"
    puts "5- Search recipes"
    puts "9- End programm"
    puts "----------------"
    gets.chomp.to_i
  end

  def user_choice(choice)
    case choice
    when 1 then @controller.list
    when 2 then @controller.create
    when 3 then @controller.update
    when 4 then @controller.destroy
    when 5 then @controller.search
    when 9
      puts "Goodbye"
      @running = false
    else
      puts "Did not understand your choice, please try again"
    end
  end

end
