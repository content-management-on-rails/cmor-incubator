class AddOwnerToCmorTimeTrackingProjects < ActiveRecord::Migration[7.1]
  def change
    add_reference :cmor_time_tracking_projects, :owner, polymorphic: true, null: false
  end
end
