require 'capybara/dsl'

module CapybaraServices
  class DigitalOceanParser < ApplicationService
    def initialize(url)
      @url = url
    end

    def call
      extend Capybara::DSL
      
      Capybara.current_driver = :remote_selenium_headless
      visit(@url)
      title = find('.HeadingStyles__StyledH1-sc-kkk1io-0').text

      comments = page.all(".CommentStyles__StyledCommentBody-sc-gn53o-7
                            .CommentStyles__StyledCommentBody-sc-gn53o-7
                            .Markdown_markdown__7Dog_",
                          visible: false).map(&:text)

      { title:, comments: }
    ensure
      Capybara.current_session.driver.quit
    end

    def self.parse_devto_article(url)
      Capybara.current_driver = :remote_selenium_headless
      visit(url)
      title = find('#main-title h1').text

      comments = page.all(".comment__body p",
                          visible: false).map(&:text)

      { title:, comments: }
    ensure
      Capybara.current_session.driver.quit
    end
  end
end
