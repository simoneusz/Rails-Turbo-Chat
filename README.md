---
<h1 align="center"> 🚀 TurboChat </h1>

[![Ruby](https://img.shields.io/badge/Ruby-3.2.2-red.svg)](https://www.ruby-lang.org/en/)
[![Rails](https://img.shields.io/badge/Rails-7.1.6-blue.svg)](https://rubyonrails.org/)
[![Turbo](https://img.shields.io/badge/Turbo-green.svg)](https://turbo.hotwired.dev/)

Modern, real-time chat application inspired by Slack, Skype and Discord — offering private and public conversations, peer-to-peer messaging, roles & permissions, and a clean, responsive UI. Built with Ruby on Rails 7, ActionCable, Hotwire Turbo, Stimulus, Bootstrap and React, it’s a feature-rich foundation for scalable and extensible communication tools.


[![work preview](https://i.imgur.com/Qr5j3nM.png)](http://www.youtube.com/watch?v=Nh9zSg3o9GY "Video Title")

##  ⭐ Features

- Realtime chat without reloading
- Service Objects architecture with minimal controllers/models code
- Per-to-per conversations
- Group conversations(public and private)
- Attachments
- Emojis
- Image, PDF and other file previews
- Threads with message replies
- Message reactions with emojis
- Smart chat roles
- User authentication with OmniAuth (social login)
- User statuses(online, offline, brb, etc)
- Contacts system(friends-like).



## 🛠 Tech Stack

* Backend: Ruby on Rails

* Frontend: ERB+React, Bootstrap

* Database: PostgreSQL

* Background Jobs: SideKiq

* Testing: RSpec


## ✅ Testing

RSpec for unit and functional tests

## 🎯 API 

RESTful API built with Ruby on Rails that serves as the backbone for a real-time chat application with user management, room-based messaging, and social features.
### Core Features
- Authentication & Authorization: JWT-based authentication with role-based access control
- Real-time Messaging: WebSocket support for instant message delivery
- Room Management: public/private rooms with participant management
- Contact System: friend requests and contact management
- Message Reactions: emoji reactions and threaded conversations
- User Presence: user statuses (online, offline, etc.) tracking and notifications
- Search & Filtering: advanced custom DLS for API quering, capabilities with pagination
- Error Handling & Validation: json error responses with propper HTTP status codes

### API Architecture & Design Patterns:
- Transaction Pattern: Each API endpoint uses dedicated Transaction classes that orchestrate the entire request lifecycle
- Service Layer: Business logic is encapsulated in focused Service classes that handle specific domain operations
- Authorization Layer: Pundit-based authorization with dedicated Authorizer classes for each action
- Validation Layer: Dry-validation powered Validator classes ensure data integrity
- Serialization Layer: JSONAPI::Serializer provides consistent, standardized JSON responses

## 🚀 Installation & Setup
Check ruby and rails versions before initializing the project
```
ruby -v #ruby 3.2.2
rails -v #Rails 7.1.5.1
```

```
git clone git@github.com:simoneusz/Rails-Turbo-Chat.git
rvm use 3.2.2
cd Rails-Turbo-Chat
bundle install
rails db:create db:migrate db:seed
rails server
