# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts "seedの実行を開始"

Admin.find_or_create_by!(email: "a@a") do |admin|
  admin.password = "aaaaaa"
end

tags = ['湖（Lake）', '川（River）', '山（Mountain）', '海（Sea）', '森林（Forest）']
tag_objects = tags.each_with_index.map do |tag_name, index|
  Tag.find_or_create_by!(name: tag_name) do |tag|
    tag.post_tag_id = index
  end
end


nana = User.find_or_create_by!(email: "nana@example.com") do |user|
  user.name = "nana"
  user.password = "password"
  user.telephone_number = "00000000000"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
end

jame = User.find_or_create_by!(email: "jame@example.com") do |user|
  user.name = "jame"
  user.password = "password"
  user.telephone_number = "00000000000"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")
end

luca = User.find_or_create_by!(email: "luca@example.com") do |user|
  user.name = "luca"
  user.password = "password"
  user.telephone_number = "00000000000"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")
end

adam = User.find_or_create_by!(email: "adam@example.com") do |user|
  user.name = "adam"
  user.password = "password"
  user.telephone_number = "00000000000"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user4.jpg"), filename:"sample-user4.jpg")
end

Post.find_or_create_by!(title: "湖を一望しながら整う") do |post|
  post.sauna_name = "Biwako Sauna"
  post.address = "滋賀県高島市マキノ町海津"
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"), filename:"sample-post1.jpg")
  post.caption = "湖に囲まれながらサウナ！湖に飛び込んで、自然の水風呂最高！"
  post.user = nana
  post.tag_ids = [tag_objects[0].id]
end

Post.find_or_create_by!(title: "雪サウナ") do |post|
  post.sauna_name = "スノーサウナ"
  post.address = "長野県東御市和"
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.jpg"), filename:"sample-post2.jpg")
  post.caption = "冬限定の大自然！長野の雪景色"
  post.user = jame
  post.tag_ids = [tag_objects[2].id]
end

Post.find_or_create_by!(title: "迫力感がえぐ！") do |post|
  post.sauna_name = "やまほっと"
  post.address = "宮城県加美郡加美町"
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post3.jpg"), filename:"sample-post3.jpg")
  post.caption = "目の前が山って、こんなサウナ見たことある？"
  post.user = luca
  post.tag_ids = [tag_objects[2].id]
end

Post.find_or_create_by!(title: "日本最北端！？") do |post|
  post.sauna_name = "ほっととのう"
  post.address = "北海道稚内市"
  post.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post4.jpg"), filename:"sample-post4.jpg")
  post.caption = "日本の北のサウナは南国のようなホットな場所だった。"
  post.user = adam
  post.tag_ids = [tag_objects[3].id]
end

puts "seedの実行が完了しました"

