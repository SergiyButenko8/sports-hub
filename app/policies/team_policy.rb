class TeamPolicy < ApplicationPolicy
  %w[index? new? edit? create? update? change_team_visibility? move_to_sub_category? move_position?
     destroy?].each do |action|
    define_method(action) do
      user.admin?
    end
  end
end
