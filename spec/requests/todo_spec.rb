require 'rails_helper'

RSpec.describe TodosController, type: :request do
  describe 'GET #index' do
    let!(:first_todo) { FactoryBot.create(:todo, title: 'first_title', text: 'first_text') }
    let!(:second_todo) { FactoryBot.create(:todo, title: 'second_title', text: 'second_text') }

    it 'HTTP ステータスコード 200 が返ること' do
      get '/todos'
      expect(response.status).to eq 200
    end

    it '作成した数だけ todo が JSON 出力されること' do
      get '/todos'
      jsons = JSON.parse(response.body)
      expect(jsons.size).to eq 2
    end

    it '作成した first_todo の内容が正しく JSON 出力されること' do
      get '/todos'
      jsons = JSON.parse(response.body)
      expect(jsons[0]['id']).to eq first_todo.id
      expect(jsons[0]['title']).to eq 'first_title'
      expect(jsons[0]['text']).to eq 'first_text'
      expect(jsons[0]['created_at']).to eq first_todo.created_at.as_json
    end

    it '作成した second_todo の内容が正しく JSON 出力されること' do
      get '/todos'
      jsons = JSON.parse(response.body)
      expect(jsons[1]['id']).to eq second_todo.id
      expect(jsons[1]['title']).to eq 'second_title'
      expect(jsons[1]['text']).to eq 'second_text'
      expect(jsons[1]['created_at']).to eq second_todo.created_at.as_json
    end

    it 'ID が　UUID であること' do
      get '/todos'
      jsons = JSON.parse(response.body)
      expect(jsons[0]['id'].length).to eq 36
      expect(jsons[1]['id'].length).to eq 36
    end

    it '出力される JSON に updated_at が含まれていないこと' do
      get '/todos'
      jsons = JSON.parse(response.body)
      expect(jsons[0].keys).not_to include 'updated_at'
      expect(jsons[1].keys).not_to include 'updated_at'
    end
  end
end
