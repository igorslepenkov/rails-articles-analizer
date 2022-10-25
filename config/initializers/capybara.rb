require 'webdrivers'
require 'selenium-webdriver'

Capybara.run_server = false
Capybara.default_max_wait_time = 1
Capybara.ignore_hidden_elements = false

chrome_bin = ENV.fetch('GOOGLE_CHROME_SHIM', nil)

Selenium::WebDriver::Chrome.path = chrome_bin if chrome_bin

Capybara.register_driver :remote_selenium_headless do |app|
  selenium_options = Selenium::WebDriver::Chrome::Options.new
  selenium_options.add_argument('--headless')
  selenium_options.add_argument('--window-size=1400,1400')
  selenium_options.add_argument('--no-sandbox')
  selenium_options.add_argument('--disable-dev-shm-usage')

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: selenium_options
  )
end
