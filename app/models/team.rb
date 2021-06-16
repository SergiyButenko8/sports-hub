class Team < ApplicationRecord
  acts_as_list scope: :sub_category, add_new_at: :top
  validates :label, presence: true, uniqueness: true, length: { minimum: 3 }

  belongs_to :sub_category
end
