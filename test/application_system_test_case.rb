require "test_helper"
require "selenium/webdriver"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
  include Warden::Test::Helpers
  setup   { Warden.test_mode! }
  teardown { Warden.test_reset! }
end
