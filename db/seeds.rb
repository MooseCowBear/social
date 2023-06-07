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

emails = ["alice@test.com", "barry@test.com", "chris@test.com", "darrel@test.com", "edwin@test.com"]

emails.each do |e|
  User.create!(email: e, password: "123456")
end

requesters = [1, 2, 3, 4]

requesters.each do |r|
  FriendRequest.send_request(User.find(r), User.find(r + 1))
end
