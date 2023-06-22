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

alice = User.find_by(email: "alice@fake.com")

profile = Profile.new(user_id: alice.id, username: "AliceInWonderLand", location: "Through the Looking Glass", interests: "books, cats, large mushrooms, growing, shrinking", birthday: 20.years.ago)
profile.image.attach(io: File.open('app/assets/images/emma_profile.jpeg'), filename: 'emma_profile.jpeg', content_type: 'image/jpeg')
profile.save!

#want some established friends, not just requested ones...

friends = ["harry@fake.com", "martin@fake.com", "malek@fake.com", "gloria@fake.com", "lily@fake.com", "pierre@fake.com"]

friends.each do |f|
  begin
    friend = User.find_by(email: f)
    FriendRequest.send_request(alice, friend)
    FriendRequest.accept_request(alice, friend)
  rescue
    #in case the random friend requests above already sent these
  end
end

titles = ["Best Day Ever!", "No one saw that coming", "And they said it was a bad idea", "Who Dis",
          "I can't remember the last time", "Deja Vue"]

content = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus'\
          ' quis urna lobortis, interdum sem ut, vehicula ipsum. Nulla ornare '\
          'aliquam facilisis. Curabitur tincidunt sem at pharetra iaculis. Nunc'\
          ' lacinia justo eu augue pellentesque lacinia. Cras bibendum, ex id '\
          'sodales iaculis, quam diam facilisis mauris, id porttitor neque leo'\
          ' vitae metus. Sed gravida rutrum fermentum. Donec tristique convall'\
          'is accumsan. Curabitur et tristique tellus, at mattis odio. Nam vel'\
          ' velit arcu. Nulla pharetra sem eget dolor pretium elementum. Vesti'\
          'bulum mollis neque at sollicitudin auctor. Etiam ut sem vehicula, s'\
          'uscipit orci sed, efficitur urna. Curabitur quis metus porttitor, c'\
          'onvallis lacus sed, hendrerit eros. Duis ante est, efficitur vitae n'\
          'ibh ut, ultricies interdum tortor. Aenean lobortis dolor id blandit'\
          ' facilisis. Aliquam ac neque tincidunt massa lobortis iaculis. Vivam'\
          'us accumsan nisl sed nibh tempor pharetra. Sed dolor elit, elementum '\
          'quis purus ac, pulvinar tempus libero. Nam sapien elit, scelerisque'\
          ' at mauris at, molestie laoreet ligula. Nullam euismod viverra nibh.'\
          ' Etiam dolor nibh, congue vel eleifend non, ornare non felis. Sed '\
          'pretium eu nisl sed pellentesque. Pellentesque ut viverra tortor, e'\
          'get volutpat dui. Suspendisse rutrum mauris non nunc ultrices suscip'\
          'it. Etiam pharetra nunc sit amet purus iaculis volutpat. Etiam sit a'\
          'met varius eros. Mauris facilisis sagittis.'

now = Date.now

friends.each_with_index do |f, i|
  friend = User.find_by(email: f)
  random_end = (100..1388).to_a.sample
  p = Post.new(user_id: friend.id, title: titles[i], body: content[0..random_end])
  rand_time = (2..10).to_a.sample
  p.created_at = now - rand_time
  p.save!
end

post1 = Post.new(user_id: alice.id, title: "First Post", body: content)
post1.created_at = now - 4
post1.save!

post2 = Post.new(user_id: alice.id, title: "Another Post", body: content[0..200])
post2.creates_at = now - 3
post2.save!

post3 = Post.new(user_id: alice.id, title: "Ready to go", body: content[0..400])
post3.created_at = now - 2
post3.image.attach(io: File.open('app/assets/images/leaf.jpeg'), filename: 'leaf.jpeg', content_type: 'image/jpeg')
post3.save!

post4 = Post.new(user_id: alice.id, title: "Proudest Moment Ever")
post4.created_at = now - 1
post4.image.attach(io: File.open('app/assets/images/branch.jpeg'), filename: 'branch.jpg', content_type: 'image/jpeg')
post4.save!

#want comments for posts, and likes
comments = ["So cool.", "Yay", "I think not.", "Maybe another day", "first"]
posts = Post.all
posts.each do |p|
  rand = (0..4).to_a.sample(3)
  a = p.comments.new(body: comments[rand[0]], user_id: User.find_by(email: "alice@fake.com").id)
  b = p.comments.new(body: comments(rand[1]), user_id: User.find_by(email: "harry@fake.com").id)
  c = cc.comments.new(body: comments[rand[2]], user_id: User.find_by(email: "lily@fake.com").id)
  #pick created at times
  a.created_at = p.created_at 
  b.created_at = p.created_at + 1
  c.created_at = cc.created_at + 1
  a.save!
  b.save!
  c.save!

  like_count = (0..3).to_sample
  like_count.times do |l|
    p.likes.create!(user_id: User.find_by(email: emails[l]).id)
    if l % 2 == 0
      p.likes.create!(user_id: alice.id)
    end
  end
end
