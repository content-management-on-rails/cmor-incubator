class AddExternalStateToCmorTimeTrackingIssues < ActiveRecord::Migration[7.1]
  def change
    add_column :cmor_time_tracking_issues, :external_state, :string
  end
end
