FactoryBot.define do
  factory :todo do
    sequence(:title) { |i| "タイトル#{i}" }
    sequence(:text) { |i| "テキスト#{i}" }
  end
end
