# config
module TurboUrlsTestApp
  class Application < Rails::Application
    config.secret_token = "My death waits there between your thighs
Your cool fingers will close my eyes
Let's think of that and the passing time"
    config.eager_load = false
    config.active_support.deprecation = :log
  end
  Application.initialize!
end

# controllers
class ApplicationController < ActionController::Base
end
