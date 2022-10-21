require 'capybara/dsl'

module CapybaraServices
  class DigitalOceanParser < ApplicationService
    include Capybara::DSL

    def initialize(url)
      @url = url
    end

    def call
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
  end
end
