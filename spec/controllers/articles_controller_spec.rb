require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe 'GET index' do
    it 'should assing @articles' do
      articles = Article.all

      get :index
      expect(assigns(:articles)).to eq(articles)
    end

    it 'should render the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe 'GET new' do
    it 'should assing @article' do
      get :new
      expect(assigns(:article)).to be_a_new(Article)
    end

    it 'should render the new template' do
      get :new
      expect(response).to render_template('new')
    end
  end

  describe 'POST create' do
    it 'should create new Article with valid url' do
      post 'create', params: {article: {url: "https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes"}}
      expect(Article.count).to eq 1
    end

    it 'should redirect to article_path after successful creating' do
      post 'create', params: {article: {url: "https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes"}}
      expect(response).to redirect_to articles_path
    end

    it 'should not create new Article with invalid url' do
      post 'create', params: {article: {url: "lalalalalalalaal"}}
      expect(Article.count).to eq 0
    end

    it 'should redirect to root_path if domain is not supported' do
      post 'create', params: {article: {url: "https://medium.com/@james.a.hughes/using-the-reduce-method-in-ruby-907f3c18ae1f"}}
      expect(response).to redirect_to root_path
    end
  end
end