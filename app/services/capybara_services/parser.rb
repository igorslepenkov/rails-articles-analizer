require 'capybara/dsl'

module CapybaraServices
  module Parser
    extend Capybara::DSL

    Capybara.run_server = false

    def self.parse_article(_url)
      Capybara.register_driver :selenium do |app|
        Capybara::Selenium::Driver.new(app, browser: :chrome)
      end

      Capybara.current_driver = :selenium

      visit('https://medium.com/yardcouch-com/youtube-is-dead-and-something-new-is-coming-132322b09be6')

      title = find('.pw-post-title').text
      puts title
    end
  end
end
