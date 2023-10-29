module Cmor::TimeTracking
  class Issue < ApplicationRecord
    belongs_to :project
    has_many :items, dependent: :restrict_with_error

    validates :identifier, presence: true, uniqueness: {scope: :project_id}

    def human
      "#{project.identifier}##{identifier}"
    end

    def items_count
      items.count
    end
  end
end
