require 'capybara/dsl'

module CapybaraServices
  module Parser
    extend Capybara::DSL

    Capybara.run_server = false

    def self.parse_article(url)
      Capybara.current_driver = :selenium
      visit(url)
    end
  end
end
