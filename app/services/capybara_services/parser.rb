require 'capybara/dsl'

module CapybaraServices
  module Parser
    extend Capybara::DSL
    def self.parse_digital_ocean_article(url)
      Capybara.current_driver = :remote_selenium_headless
      visit(url)
      title = find('.HeadingStyles__StyledH1-sc-kkk1io-0').text

      comments = page.all('.CommentStyles__StyledCommentBody-sc-gn53o-7', visible: false).map(&:text)

      { title:, comments: }
    ensure
      Capybara.current_session.driver.quit
    end
  end
end
