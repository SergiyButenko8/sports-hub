# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum status: {active: 0, blocked: 1 }
  enum role: { user: 0, admin: 1 }

  def full_name
      if self.first_name.present? && self.last_name.present?
        name = "#{self.first_name} #{self.last_name}".titleize
      else
        name = "---"
    end
    name
  end
end
