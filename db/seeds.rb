# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

owners = %w(dania jerica donny forrest rufus)
repos = %w(crumis dirth forkle pystic spinistor)
healths = [10, 30, 50, 70, 90]
owners.zip(repos, healths).each do |(o, r, h)|
  Project.create(owner: o, repo: r, health: h)
end
