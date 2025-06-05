class Photo < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :likes
  has_many :liked_by_users, through: :likes, source: :user

  validates :title, presence: true
end
