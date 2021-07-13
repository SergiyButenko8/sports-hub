class SubCategory < ApplicationRecord
  acts_as_list scope: :category, add_new_at: :top
  validates :label, presence: true, uniqueness: true, length: { minimum: 3 }

  belongs_to :category
  has_many :teams, dependent: :destroy
  has_many :articles, dependent: :destroy
end
