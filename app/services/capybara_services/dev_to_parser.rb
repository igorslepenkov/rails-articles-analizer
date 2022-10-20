require 'capybara/dsl'

module CapybaraServices
  class DevToParser < ApplicationService
    def initialize(url)
      @url = url
    end

    def call
      extend Capybara::DSL

      Capybara.current_driver = :remote_selenium_headless
      visit(@url)
      title = find('#main-title h1').text

      comments = page.all('.comment__body p',
                          visible: false).map(&:text)

      { title:, comments: }
    ensure
      Capybara.current_session.driver.quit
    end
  end
end
