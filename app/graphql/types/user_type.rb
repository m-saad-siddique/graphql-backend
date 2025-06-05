# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :email, String, null: false
    field :photos, [Types::PhotoType], null: true  # ✅ Add this line

    def photos
      object.photos
    end
  end
end
