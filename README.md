# Odin Project - Facebook Clone

This is an implementation of the [final project](https://www.theodinproject.com/lessons/ruby-on-rails-rails-final-project) in the [Odin Project's](https://www.theodinproject.com) Rails Path. 

It is a social media web app inspired by Facebook. 

## Features

- Authorization with the Devise Gem.
- Sign in with Google via Omniauth.
- Custom error pages.
- A user can send friend requests to other users.
- A user must accept a friend request in order to become friends.
- A user can create posts, and posts may consist of 1. text, 2. an image upload, or 3. both text and an image upload.
- A user can comment on posts.
- A user can reply to a comment (currently nested comments are limited to a depth of 2, but could in principle be infinite)
- A user may like/unlike a post.
- A user's homepage displays the posts from their friends in reverse chronological order of creation. 
- A user may create a profile. 
- A user may upload an avatar. 
- Notifications are sent whenever a friend publishes a new post, someone comments on a user's post, someone replies to user's comment, user has received a friend request. New notificaiton are broadcasted and so appear in real time. 
- A user may search for other users. 
- Stimulus controller actions to open and close the navigation menu, toggle visibility of declined friend requests.
- Light and dark modes

## The Database

(not including Active Storage image uploads)

![alt text](readme_resources/uml.jpg "uml diagram of databases") 

## Screenshots

A user's show page (light mode):

![alt text](readme_resources/user_show_page_light_cropped.png "user's page after signing in")

The navigation menu (light mode):

![alt text](readme_resources/menu_light.png "menu")

Post show page (light mode):

![alt text](readme_resources/post_show_light.png "post with comments")

User index page with search results (light mode):

![alt text](readme_resources/user_search_light.png "user search results")

New post form, embedded in page with Turbo Frame (dark mode):

![alt text](readme_resources/new_post_form_dark_cropped.png "new post form")

New comment form, embedded with Turbo Frame (dark mode):

![alt text](readme_resources/new_comment_form_dark.png "new comment form")

Friend Request index page (dark mode):

![alt text](readme_resources/friend_requests_index_dark.png "friend request page")

Error page (dark mode):

![alt text](readme_resources/404.png "404 error page")
