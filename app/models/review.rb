class Review < ApplicationRecord
    validates :rating, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  has_many :likes, dependent: :destroy
  has_many :likers, through: :likes, source: :review

  belongs_to :idea
  belongs_to :user
end
