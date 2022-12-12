# README

<div id="top"></div>
<br />
<div align="center">
  <a href="https://github.com/igorslepenkov/rails-alpha-blog">
    <img src="./images.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Rails Newslizer App</h3>

  <p align="center">Educational articles' parser and analizer project</p>
</div>

### About Project

This is my fourth small Ruby project, that I have created during my RoR internship at IThechArt company.

This is an interesting app, that uses Capybara + Selenium WebDriver(that is actually used for testing) to parse comments for articles of tech blogs <strong>(dev.to and digital ocean)</strong> and Monkey Learn ML API to analize comments' sentiment and make a decision about the whole article.

It includes only 2 models with simple associations.

The key feature, I need to mention, is wide use of services through app's workflow and tests for the app, made with RSpec.

Font made with HTML-ERB and Bootstrap 5

### Built With

- [Ruby on Rails](https://rubyonrails.org/)
- [Bootstrap](https://getbootstrap.com/docs/5.0/getting-started/introduction/)
- [MonkeyLearn](https://monkeylearn.com/)
- [Capybara](http://teamcapybara.github.io/capybara/)
- [RSpec](https://rspec.info/)
