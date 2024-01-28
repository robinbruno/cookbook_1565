require_relative "router"
require_relative "cookbook"
require_relative "controller"

repo = Cookbook.new
controller = Controller.new(repo)
router = Router.new(controller)

router.run
