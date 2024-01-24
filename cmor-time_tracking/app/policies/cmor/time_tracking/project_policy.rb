module Cmor::TimeTracking
  class ProjectPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        # define the scope to only include records of the teams the user is a member of
        scope.where(owner: user)
      end
    end

    def index?
      true
    end

    def show?
      true
    end
  end
end
