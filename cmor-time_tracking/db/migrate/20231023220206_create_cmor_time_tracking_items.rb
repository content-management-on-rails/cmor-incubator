class CreateCmorTimeTrackingItems < ActiveRecord::Migration[7.1]
  def change
    create_table :cmor_time_tracking_items do |t|
      t.references :owner, null: false, foreign_key: {to_table: Cmor::TimeTracking::Configuration.item_owner_class.call.table_name}
      t.references :issue, null: true, foreign_key: {to_table: :cmor_time_tracking_issues}
      t.timestamp :start_at
      t.timestamp :end_at
      t.string :year
      t.string :month
      t.integer :duration
      t.string :external_issue_identifier
      t.string :billing_state
      t.text :description

      t.timestamps
    end
  end
end
