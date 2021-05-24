class User < ApplicationRecord
  enum status: [ :active, :blocked ]
  enum role: [ :user, :admin ]
end
