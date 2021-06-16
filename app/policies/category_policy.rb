class CategoryPolicy < ApplicationPolicy
  %w[index? new? create? edit? update? change_cat_visibility? move_position? destroy?].each do |action|
    define_method(action) do
      user.admin?
    end
  end
end
