require_relative "router"
require_relative "cookbook"
require_relative "controller"

csv_file_path = File.join(__dir__, "recipes.csv")

repo = Cookbook.new(csv_file_path)
controller = Controller.new(repo)
router = Router.new(controller)

router.run
