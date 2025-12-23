require "capybara/rspec"
require "selenium/webdriver"

Capybara.register_driver :remote_chrome do |app|
  url = ENV.fetch("SELENIUM_REMOTE_URL", "http://selenium:4444/wd/hub")

  options = Selenium::WebDriver::Chrome::Options.new
  %w[headless no-sandbox disable-dev-shm-usage].each { |arg| options.add_argument(arg) }

  Capybara::Selenium::Driver.new(
    app,
    browser: :remote,
    url: url,
    capabilities: options
  )
end

Capybara.server_host = "0.0.0.0"
Capybara.server_port = 3001
Capybara.app_host = "http://web:#{Capybara.server_port}"

RSpec.configure do |config|
  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
  end

  config.before(:each, type: :system, js: true) do
    driven_by :remote_chrome
  end
end
