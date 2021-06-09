# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: { active: 0, blocked: 1 }
  enum role: { user: 0, admin: 1 }
  scope :online, -> { where("last_seen > ?", 10.minutes.ago) }
  scope :offline, -> { where("last_seen <= ?", 10.minutes.ago) }

  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.ransackable_scopes(auth_object = nil)
    super + %i[online offline]
  end

  def full_name
    "#{first_name} #{last_name}".titleize
  end

  def online
    last_seen > 10.minutes.ago
  end
end
