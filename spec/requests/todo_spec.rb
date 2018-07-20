require 'rails_helper'

RSpec.describe TodosController, type: :request do
  describe 'GET #index' do
    context 'todo が 1つ以上作成されている場合' do
      let!(:todo) { FactoryBot.create(:todo) }

      it 'HTTP ステータスコード 200 を返すこと' do
        get '/todos'
        expect(response.status).to eq 200
      end

      it '作成した todo の内容を正しく JSON 形式で返すこと' do
        get '/todos'
        json = JSON.parse(response.body)
        expect(json[0]['id']).to eq todo.id
        expect(json[0]['title']).to eq todo.title
        expect(json[0]['text']).to eq todo.text
        expect(json[0]['created_at']).to eq todo.created_at.as_json
      end

      it '返す JSON の keys が仕様通りであること' do
        get '/todos'
        json = JSON.parse(response.body)
        expect(json[0].keys).to contain_exactly('id', 'title', 'text', 'created_at')
      end
    end

    context 'todo が3つ作成されている場合' do
      before do
        3.times { FactoryBot.create(:todo) }
      end

      it '3つの todo を JSON 形式で返すこと' do
        get '/todos'
        json = JSON.parse(response.body)
        expect(json.size).to eq 3
      end
    end
  end

  describe 'POST #create' do
    let(:params) { { title: 'todo_title', text: 'todo_text' } }

    it 'HTTP ステータスコード 201 を返すこと' do
      post '/todos', params: params
      expect(response).to have_http_status(:created)
    end

    it 'POST した title と text を正しく JSON 形式で返すこと' do
      post '/todos', params: params
      json = JSON.parse(response.body)
      expect(json['title']).to eq params[:title]
      expect(json['text']).to eq params[:text]
    end

    it '返す JSON の keys が仕様通りであること' do
      post '/todos', params: params
      json = JSON.parse(response.body)
      expect(json.keys).to contain_exactly('id', 'title', 'text', 'created_at')
    end

    it 'todo が新規作成されること' do
      expect { post '/todos', params: params }.to change { Todo.count }.by(1)
    end
  end

  describe 'GET #show' do
    let!(:todo) { FactoryBot.create(:todo) }

    it 'HTTP ステータスコード 200 を返すこと' do
      get "/todos/#{todo.id}"
      expect(response.status).to eq 200
    end

    it '指定した todo の内容を正しく JSON 形式で返すこと' do
      get "/todos/#{todo.id}"
      json = JSON.parse(response.body)
      expect(json['id']).to eq todo.id
      expect(json['title']).to eq todo.title
      expect(json['text']).to eq todo.text
      expect(json['created_at']).to eq todo.created_at.as_json
    end

    it '返す JSON の keys が仕様通りであること' do
      get "/todos/#{todo.id}"
      json = JSON.parse(response.body)
      expect(json.keys).to contain_exactly('id', 'title', 'text', 'created_at')
    end
  end

  describe 'PATCH #update' do
    let(:params) { { title: 'updated_title', text: 'updated_text' } }

    let!(:todo) { FactoryBot.create(:todo, title: 'todo_title', text: 'todo_text') }

    it 'HTTP ステータスコード 200 を返すこと' do
      patch "/todos/#{todo.id}", params: params
      expect(response.status).to eq 200
    end

    it 'PATCH した title と text を正しく JSON 形式で返すこと' do
      patch "/todos/#{todo.id}", params: params
      json = JSON.parse(response.body)
      expect(json['title']).to eq params[:title]
      expect(json['text']).to eq params[:text]
    end

    it '返す JSON の keys が仕様通りであること' do
      patch "/todos/#{todo.id}", params: params
      json = JSON.parse(response.body)
      expect(json.keys).to contain_exactly('id', 'title', 'text', 'created_at')
    end

    it 'todo の title が更新されること' do
      expect { patch "/todos/#{todo.id}", params: params }
        .to change { Todo.find(todo.id).title }.from(todo.title).to(params[:title])
    end

    it 'todo の text が更新されること' do
      expect { patch "/todos/#{todo.id}", params: params }
        .to change { Todo.find(todo.id).text }.from(todo.text).to(params[:text])
    end
  end

  describe 'DELETE #destroy' do
    let!(:todo) { FactoryBot.create(:todo) }

    it 'HTTP ステータスコード 200 を返すこと' do
      delete "/todos/#{todo.id}"
      expect(response.status).to eq 200
    end

    it 'DELETE した todo の内容を正しく JSON 形式で返すこと' do
      delete "/todos/#{todo.id}"
      json = JSON.parse(response.body)
      expect(json['id']).to eq todo.id
      expect(json['title']).to eq todo.title
      expect(json['text']).to eq todo.text
      expect(json['created_at']).to eq todo.created_at.as_json
    end

    it 'todo が削除されること' do
      expect { delete "/todos/#{todo.id}" }.to change { Todo.count }.by(-1)
    end
  end
end
