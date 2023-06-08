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

emails.each do |e|
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

#want some established friends, not just requested ones...

alice = User.find_by(email: "alice@fake.com")

friends = ["harry@fake.com", "martin@fake.com", "malek@fake.com", "gloria@fake.com"]

friends.each do |f|
  begin
    friend = User.find_by(email: f)
    FriendRequest.send_request(alice, friend)
    FriendRequest.accept_request(alice, friend)
  rescue
    #in case the random friend requests above already sent these
  end
end

titles = ["Best Day Ever!", "No one saw that coming", "And they said it was a bad idea", "Who Dis"]

content = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer viverra diam et dui finibus mollis. Pellentesque ex ipsum, molestie in ante in, sagittis convallis orci. Vivamus sed ultricies nulla, at blandit nulla. In orci nisi, aliquam eget lectus sit amet, viverra dignissim mauris. Maecenas pellentesque ut ante vel dapibus. Suspendisse."

friends.each_with_index do |f, i|
  friend = User.find_by(email: f)
  Post.create!(user_id: friend.id, title: titles[i], body: content)
end

Post.create!(user_id: alice.id, title: "First Post", body: content)
Post.create!(user_id: alice.id, title: "Another Post", body: content)
Post.create!(user_id: alice.id, title: "And because we want something on the page...", body: content)

