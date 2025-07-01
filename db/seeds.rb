# db/seeds.rb
puts "Nettoyage de la base de données..."
Article.destroy_all
User.destroy_all

puts "Création de 5 utilisateurs..."
users = []
5.times do
  users << User.create!(
    email: Faker::Internet.unique.email,
    password: 'password'
  )
end

puts "Création de 30 articles..."
30.times do
  Article.create!(
    title: Faker::Book.title,
    content: Faker::Lorem.paragraph(sentence_count: 15),
    user: users.sample # Associe un utilisateur au hasard
  )
end

puts "Seed terminé !"