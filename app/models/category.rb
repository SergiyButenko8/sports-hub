class Category < ApplicationRecord
  acts_as_list add_new_at: :top
  validates :label, presence: true, uniqueness: true, length: { minimum: 3 }

  has_many :sub_categories, dependent: :destroy
end
