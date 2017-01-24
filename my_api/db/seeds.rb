# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

10.times do
  Todo.create(
    title: Faker::Hipster.sentence(2),
    completed: Faker::Boolean.boolean(0.3),
    order: Faker::Number.number(4)
  )
end
