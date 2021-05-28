# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: { active: 0, blocked: 1 }
  enum role: { user: 0, admin: 1 }

  def full_name
    if first_name.present? && last_name.present?
      "#{first_name} #{last_name}".titleize
    else
      "---"
    end
  end
end
