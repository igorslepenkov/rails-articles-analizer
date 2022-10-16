require 'webdrivers'
require 'selenium-webdriver'

Capybara.run_server = false
Capybara.default_max_wait_time = 1
Capybara.ignore_hidden_elements = false

Capybara.register_driver :remote_selenium_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--window-size=1400,1400')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options:
  )
end
