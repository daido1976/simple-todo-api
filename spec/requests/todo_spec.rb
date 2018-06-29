require 'rails_helper'

RSpec.describe TodosController, type: :request do
  describe 'GET #index' do
    context 'todo が 1つ以上作成されている場合' do
      let!(:todo) { FactoryBot.create(:todo) }

      it 'HTTP ステータスコード 200 が返ること' do
        get '/todos'
        expect(response.status).to eq 200
      end

      it '作成した todo の内容が正しく JSON 出力されること' do
        get '/todos'
        jsons = JSON.parse(response.body)
        expect(jsons[0]['id']).to eq todo.id
        expect(jsons[0]['title']).to eq todo.title
        expect(jsons[0]['text']).to eq todo.text
        expect(jsons[0]['created_at']).to eq todo.created_at.as_json
      end

      it '出力される JSON の keys が仕様通りであること' do
        get '/todos'
        jsons = JSON.parse(response.body)
        expect(jsons[0].keys).to eq %w[id title text created_at]
      end
    end

    context 'todo が3つ作成されている場合' do
      before do
        3.times { FactoryBot.create(:todo) }
      end

      it '3つの todo が JSON 出力されること' do
        get '/todos'
        jsons = JSON.parse(response.body)
        expect(jsons.size).to eq 3
      end
    end
  end
end
