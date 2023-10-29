class CreateCmorTimeTrackingIssues < ActiveRecord::Migration[7.1]
  def change
    create_table :cmor_time_tracking_issues do |t|
      t.references :project, null: false, foreign_key: {to_table: :cmor_time_tracking_projects}
      t.string :identifier
      t.string :summary
      t.text :description

      t.timestamps
    end
  end
end
