3.times do |no|
  Todo.create(title: "title_#{no}", text: "text_#{no}")
end
