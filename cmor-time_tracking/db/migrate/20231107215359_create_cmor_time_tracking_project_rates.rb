class CreateCmorTimeTrackingProjectRates < ActiveRecord::Migration[7.1]
  def change
    create_table :cmor_time_tracking_project_rates do |t|
      t.references :project, null: false, foreign_key: {to_table: :cmor_time_tracking_projects}
      t.references :rate, null: false, foreign_key: {to_table: :cmor_time_tracking_rates}
      t.timestamp :active_from
      t.timestamp :active_to

      t.timestamps
    end
  end
end
