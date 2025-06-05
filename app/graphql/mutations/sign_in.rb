# frozen_string_literal: true

module Mutations
  class SignIn < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(email:, password:)
      user = User.find_by(email: email)

      if user&.valid_password?(password)
        token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
        { token: token, user: user }
      else
        raise GraphQL::ExecutionError, "Invalid email or password"
      end
    end
  end
end
