# Building a Backend-Only GraphQL API with Rails: Photostock Example

## Table of Contents
1. [Introduction](#introduction)
2. [Why GraphQL for Backend APIs?](#why-graphql-for-backend-apis)
3. [Prerequisites](#prerequisites)
4. [Project Setup](#project-setup)
5. [Authentication](#authentication)
6. [File Uploads](#file-uploads)
7. [GraphQL Schema Design](#graphql-schema-design)
8. [Example Queries & Mutations](#example-queries--mutations)
9. [Testing & Error Handling](#testing--error-handling)
10. [Performance & Security](#performance--security)
11. [Deployment](#deployment)
12. [Further Resources](#further-resources)

---

## Introduction
This tutorial demonstrates how to build a backend-only GraphQL API for a photostock application using Ruby on Rails. You'll learn not just how to implement features, but also why each step is necessary, what alternatives exist, and best practices for production-ready APIs.

---

## Why GraphQL for Backend APIs?
**GraphQL** is a query language for APIs that allows clients to request exactly the data they need. For backend-only APIs, GraphQL offers:
- **Single endpoint** for all data operations
- **Flexible queries**: clients control the shape of the response
- **Strong typing**: schema defines data structure
- **Efficient data fetching**: reduces over- and under-fetching

**Alternatives:**
- **REST**: Simpler, but less flexible; multiple endpoints
- **gRPC**: High performance, but more complex and less web-friendly
- **JSON:API**: Standardized REST, but not as flexible as GraphQL

**Best for:**
- Complex data relationships
- Multiple client types (web, mobile)
- Evolving APIs

---

## Prerequisites
- Ruby 3.2+
- Rails 7+
- PostgreSQL (recommended for production)
- Basic knowledge of Rails and GraphQL concepts

---

## Project Setup

### 1. Generate a Rails API-Only App
```bash
rails new photostock-api --api --database=postgresql
cd photostock-api
```
**Why `--api`?**
- Removes view and asset middleware
- Optimized for API-only use

### 2. Add Required Gems
Edit your `Gemfile`:
```ruby
gem 'graphql' # GraphQL core
gem 'graphiql-rails', group: :development # In-browser IDE
gem 'devise' # Authentication
gem 'devise-jwt' # JWT for stateless auth
gem 'apollo_upload_server' # File uploads in GraphQL
gem 'rack-cors' # CORS support
gem 'active_storage_validations' # (optional) for file validations
```
Then run:
```bash
bundle install
```

### 3. Install GraphQL and Devise
```bash
rails generate graphql:install
rails generate devise:install
rails generate devise User
rails db:migrate
```

**Alternatives:**
- For authentication: `jwt` gem, `sorcery`, or custom solutions
- For file uploads: direct S3 upload, Shrine gem

---

## Authentication

### Why JWT?
- Stateless, scalable, works well for APIs
- No server-side session storage

### Setup
1. Add JWT support to Devise:
   - In `User` model:
     ```ruby
     devise :database_authenticatable, :registerable, :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist
     ```
   - Generate the denylist model:
     ```bash
     rails generate model JwtDenylist jti:string:index exp:datetime
     rails db:migrate
     ```
   - Configure Devise for JWT in `config/initializers/devise.rb`:
     ```ruby
     config.jwt do |jwt|
       jwt.secret = Rails.application.credentials.secret_key_base
       jwt.dispatch_requests = [['POST', %r{^/login$}]]
       jwt.revocation_requests = [['DELETE', %r{^/logout$}]]
       jwt.expiration_time = 1.day.to_i
     end
     ```
2. Update routes for login/logout as needed.

**Alternatives:**
- OAuth2 (for third-party logins)
- API keys (for service-to-service)

---

## File Uploads

### Why Active Storage?
- Built-in with Rails
- Supports local and cloud (S3, GCS, etc.)
- Handles file metadata and variants

### Setup
```bash
rails active_storage:install
rails db:migrate
```
- In `Photo` model:
  ```ruby
  has_one_attached :image
  validates :image, presence: true
  ```
- In GraphQL, use `apollo_upload_server` for file upload support.

**Alternatives:**
- Shrine gem (more flexible, but more setup)
- Direct-to-cloud uploads (for large files)

---

## GraphQL Schema Design

### Types
- `UserType`: id, username, email, photos
- `PhotoType`: id, title, description, image_url, user, likes_count
- `LikeType`: id, user, photo

### Example Type Definition
```ruby
# app/graphql/types/photo_type.rb
module Types
  class PhotoType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :description, String, null: true
    field :image_url, String, null: false
    field :user, Types::UserType, null: false
    field :likes_count, Integer, null: false

    def image_url
      Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true)
    end
    def likes_count
      object.likes.count
    end
  end
end
```

### Queries
- List photos (with pagination)
- Get photo by ID
- Current user

### Mutations
- Create photo (with file upload)
- Like/unlike photo
- Register/login user

**Best Practices:**
- Use `includes` to avoid N+1 queries
- Validate inputs in mutations
- Use context for current user

---

## Example Queries & Mutations

### Query: List Photos
```graphql
query {
  photos(limit: 10, offset: 0) {
    id
    title
    imageUrl
    user { username }
    likesCount
  }
}
```

### Mutation: Create Photo
```graphql
mutation($title: String!, $image: Upload!) {
  createPhoto(input: { title: $title, image: $image }) {
    photo { id title imageUrl }
    errors
  }
}
```

### Mutation: Like Photo
```graphql
mutation($photoId: ID!) {
  likePhoto(input: { photoId: $photoId }) {
    photo { id likesCount }
    errors
  }
}
```

---

## Testing & Error Handling
- Use RSpec for models and request specs
- Test GraphQL queries/mutations via POST `/graphql`
- Handle errors in mutations, return error messages in the response

**Best Practices:**
- Validate all inputs
- Return meaningful error messages
- Use factories for test data

---

## Performance & Security
- Use `includes` to prevent N+1 queries
- Add DB indexes on foreign keys
- Use pagination for large lists
- Secure file uploads (validate type/size)
- Use CORS to restrict API access
- Rate limit sensitive endpoints

---

## Deployment
- Use Docker for consistent environments
- Set `RAILS_ENV=production` and configure credentials
- Use a cloud storage service for Active Storage in production
- Monitor logs and errors

---

## Further Resources
- [GraphQL Ruby Docs](https://graphql-ruby.org/)
- [Rails Guides: GraphQL](https://guides.rubyonrails.org/graphql.html)
- [Apollo Upload Server](https://github.com/jaydenseric/apollo-upload-server)
- [Devise JWT](https://github.com/waiting-for-dev/devise-jwt)

---

*This tutorial is backend-only and production-focused. For frontend integration, see Apollo Client or Relay documentation.* 