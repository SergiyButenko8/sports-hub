class UserPolicy < ApplicationPolicy
  %w[index? show? edit? update? change_user_status? change_admin_permission? destroy?].each do |action|
    define_method(action) do
      user.admin?
    end
  end
end
