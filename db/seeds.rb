# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all
FriendRequest.destroy_all
Profile.destroy_all

names = ["alice", "harry", "martin", "malek", "gloria", 
  "steve", "horace", "emily", "emma", "evelyn", "carry",
  "ryan", "avery", "melissa", "john", "michael", "winston",
  "sarah", "evie", "alison", "mary", "zack", "pete", "phil",
  "chester", "jaime", "dana", "megan", "adam", "tammy", "eliott",
  "lara", "claire", "wesley", "henry", "josh", "david", "ben", 
  "jennifer", "kevin", "clive", "owen", "robbie", "amelia", "stacy",
  "alastair", "mackenzie", "freida", "pierre", "george", "frances",
  "betty", "olivia", "damian", "susan", "hugh", "lauren", "max", "maxine",
  "harriet", "lily"] #61

emails = names.map { |name| name + "@fake.com" }

emails.each_with_index do |e|
  user = User.create!(email: e, password: "123456")
end

requests = []
30.times do |i|
  x = (0..60).to_a.sample(2)
  begin
    FriendRequest.send_request(User.find(x[0]), User.find(x[1]))
  rescue
  end
end

