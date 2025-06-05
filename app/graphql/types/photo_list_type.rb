# frozen_string_literal: true

module Types
  class PhotoListType < Types::BaseObject
    field :total_count, Integer, null: false
    field :photos, [Types::PhotoType], null: false
  end
end
