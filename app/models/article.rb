class Article < ApplicationRecord
  mount_uploader :image, ImageUploader
  validates :alt, presence: true
  validates :headline, presence: true
  validates :caption, presence: true
  validates :content, presence: true
  validates :image, file_size: { less_than: 1.megabytes }

  belongs_to :category, optional: true
  belongs_to :sub_category, optional: true
  belongs_to :team, optional: true

  has_rich_text :content

  def associates
    "#{sub_category.label} / #{team.label}" unless sub_category.nil? && team.nil?
  end
end
