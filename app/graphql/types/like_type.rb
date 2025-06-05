# frozen_string_literal: true

module Types
  class LikeType < Types::BaseObject
    field :id, ID, null: false
    field :user, Types::UserType, null: false
    field :photo, Types::PhotoType, null: false
  end
end
