require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  describe 'GET index' do
    it 'should assing @articles' do
      articles = Article.all

      get :index
      expect(assigns(:articles)).to eq(articles)
    end

    it 'should render the index template with 200 status code' do
      get :index
      expect(response).to render_template('index')
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET new' do
    it 'should assing @article' do
      get :new
      expect(assigns(:article)).to be_a_new(Article)
    end

    it 'should render the new template with 200 status code' do
      get :new
      expect(response).to render_template('new')
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST create' do
    context 'when provided data is valid' do
      it 'should create new Article with valid url' do
        post 'create', params: { article: { url: 'https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes' } }
        expect(Article.count).to eq 1
      end
  
      it 'should redirect to article_path with 302 status code after successful creating' do
        post 'create', params: { article: { url: 'https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes' } }
        expect(response).to redirect_to articles_path
        expect(response).to have_http_status(302)
      end
    end

    context 'when provided data is invalid' do
      it 'should not create new Article with invalid url' do
        post 'create', params: { article: { url: 'lalalalalalalaal' } }
        expect(Article.count).to eq 0
      end
  
      it 'should redirect to root_path with 302 status code, if domain is not supported' do
        post 'create', params: { article: { url: 'https://medium.com/@james.a.hughes/using-the-reduce-method-in-ruby-907f3c18ae1f' } }
        expect(response).to redirect_to root_path
        expect(response).to have_http_status(302)
      end
    end

    context 'when parser did not response with title and comments' do
      before do
        allow_any_instance_of(ArticlesController).to receive(:article_params).and_return({url: 'https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes'})
        allow_any_instance_of(ArticlesController).to receive(:get_parser_response).and_return({title: '', comments: []})
      end
      
      it 'should render "new" with :bad_request status if article did not receive title from parser' do
        post 'create', params: { article: { url: 'https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes' } }
        expect(response).to have_http_status(:bad_request)
        expect(response).to render_template('new')
      end
    end
  end
end
