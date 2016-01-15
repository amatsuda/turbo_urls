$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
# load Rails first
require 'rails/all'

# load the plugin
require 'turbo_urls'

# needs to load the app next
require 'fake_app'

require 'test/unit/rails/test_help'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end
