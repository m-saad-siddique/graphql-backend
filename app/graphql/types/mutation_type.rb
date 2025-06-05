# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :like_photo, mutation: Mutations::LikePhoto
    field :upload_photo, mutation: Mutations::UploadPhoto
    field :sign_in, mutation: Mutations::SignIn
    field :sign_up, mutation: Mutations::SignUp
    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World"
    end
  end
end
