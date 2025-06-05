# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end


    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      "Hello World!"
    end


    field :me, Types::UserType, null: true
    def me
      context[:current_user]
    end

    field :photos, Types::PhotoListType, null: false do
      argument :limit, Integer, required: false, default_value: 10
      argument :offset, Integer, required: false, default_value: 0
      argument :title_contains, String, required: false
    end
    
    def photos(limit:, offset:, title_contains: nil)
      scope = Photo.all
      scope = scope.where("title ILIKE ?", "%#{title_contains}%") if title_contains.present?
    
      {
        total_count: scope.count,
        photos: scope.limit(limit).offset(offset)
      }
    end

    field :likes, [Types::LikeType], null: false

    def likes
      Like.all
    end
  end
end
