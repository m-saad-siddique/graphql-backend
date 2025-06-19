# GraphQL API Tutorial

A comprehensive GraphQL API built with Ruby on Rails, featuring a photo sharing application with user authentication, file uploads, likes, and comments.

## Features

- **GraphQL API** with queries and mutations
- **User authentication** with JWT tokens
- **Photo uploads** with Active Storage
- **Like/unlike functionality**
- **Comments system**
- **Search and filtering**
- **Comprehensive documentation** with line-by-line explanations

## Quick Start with Docker

### Prerequisites

- Docker
- Docker Compose

### Running the Application

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd graphql
   ```

2. **Start the application**
   ```bash
   docker-compose up
   ```

3. **Access the application**
   - **GraphQL Endpoint**: http://localhost:3000/graphql
   - **GraphiQL Interface**: http://localhost:3000/graphiql
   - **Tutorial Documentation**: Open `graphql_tutorial.html` in your browser

### Docker Services

- **Web**: Rails application on port 3000
- **Database**: PostgreSQL database
- **Redis**: For caching and sessions

## Development

### Running Commands

```bash
# Run Rails console
docker-compose exec web rails console

# Run database migrations
docker-compose exec web rails db:migrate

# Run tests
docker-compose exec web rails test

# View logs
docker-compose logs web
```

### Stopping the Application

```bash
docker-compose down
```

## Project Structure

```
app/graphql/
├── graphql_schema.rb          # Main schema configuration
├── types/                     # GraphQL type definitions
├── mutations/                 # Data modification operations
└── resolvers/                 # Complex data fetching logic
```

## Documentation

The complete tutorial with line-by-line explanations is available in `graphql_tutorial.html`. Open this file in your browser to access:

- GraphQL fundamentals
- Schema design
- Type definitions
- Queries and mutations
- Best practices
- External resources

## License

This project is for educational purposes.
