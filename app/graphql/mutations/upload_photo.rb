# frozen_string_literal: true

module Mutations
  class UploadPhoto < BaseMutation
    argument :title, String, required: true
    argument :image, ApolloUploadServer::Upload, required: true

    type Types::PhotoType

    def resolve(title:, image:)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Unauthorized" unless user
    
      photo = user.photos.new(title: title)
    
      if photo.save
        photo.image.attach(
          io: image.to_io,
          filename: image.original_filename,
          content_type: image.content_type
        )
        photo
      else
        raise GraphQL::ExecutionError, photo.errors.full_messages.join(", ")
      end
    rescue => e
      raise GraphQL::ExecutionError, "Upload failed: #{e.message}"
    end
    
  end
end
