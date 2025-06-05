module Mutations
  class LikePhoto < BaseMutation
    argument :photo_id, ID, required: true

    field :liked, Boolean, null: false

    def resolve(photo_id:)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Unauthorized" unless user

      photo = Photo.find(photo_id)
      like = Like.find_by(user: user, photo: photo)

      if like
        like.destroy
        { liked: false }
      else
        Like.create!(user: user, photo: photo)
        { liked: true }
      end
    end
  end
end
