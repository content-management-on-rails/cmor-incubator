class CreateCmorTimeTrackingProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :cmor_time_tracking_projects do |t|
      t.string :identifier
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
