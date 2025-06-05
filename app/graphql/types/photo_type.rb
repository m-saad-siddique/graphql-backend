# frozen_string_literal: true

module Types
  class PhotoType < Types::BaseObject
    field :id, ID, null: false
    field :title, String
    field :user, Types::UserType, null: false
    field :image_url, String, null: true
    field :likes, [Types::LikeType], null: true
    field :liked_by_current_user, Boolean, null: false

    def image_url
      Rails.application.routes.url_helpers.rails_blob_url(object.image, only_path: true) if object.image.attached?
    end

    def liked_by_current_user
      user = context[:current_user]
      return false unless user

      object.likes.exists?(user_id: user.id)
    end
  end
end
