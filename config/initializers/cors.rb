Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*' # Frontend origin
  
      resource '/graphql',
        headers: :any,
        methods: [:get, :post, :options, :head]
    end
  end