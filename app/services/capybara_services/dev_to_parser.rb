require 'capybara/dsl'

module CapybaraServices
  class DevToParser < ApplicationService
    include Capybara::DSL

    def initialize(url)
      @url = url
    end

    def call
      Capybara.current_driver = :remote_selenium_headless
      begin
        visit(@url)
        title = find('#main-title h1').text || ''
    
        comments = page.all('.comment__body p',
                            visible: false).map(&:text) || []
    
        { title:, comments: }
      rescue Capybara::ElementNotFound, Selenium::WebDriver::Error::InvalidArgumentError
        { title: '', comments: [] }
      ensure
        Capybara.current_session.driver.quit
      end
    end
  end
end
