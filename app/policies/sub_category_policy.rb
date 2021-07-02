class SubCategoryPolicy < ApplicationPolicy
  %w[index? new? edit? create? update? change_sub_visibility? move_to_category? move_position?
     destroy?].each do |action|
    define_method(action) do
      user.admin?
    end
  end
end
