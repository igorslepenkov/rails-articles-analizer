require 'capybara/dsl'

module CapybaraServices
  class DevToParser < ApplicationService
    include Capybara::DSL

    def initialize(url)
      @url = url
    end

    def call
      if(@url=~URI::regexp)
        Capybara.current_driver = :remote_selenium_headless
        visit(@url)
        title = find('#main-title h1').text
  
        comments = page.all('.comment__body p',
                            visible: false).map(&:text)
  
        { title:, comments: }
      else
        {title: '', comments: []}
      end
    ensure
      Capybara.current_session.driver.quit
    end
  end
end
