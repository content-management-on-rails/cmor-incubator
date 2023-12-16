class AddIdentifierToCmorTimeTrackingProjectRates < ActiveRecord::Migration[7.1]
  def change
    add_column :cmor_time_tracking_project_rates, :identifier, :string
  end
end
