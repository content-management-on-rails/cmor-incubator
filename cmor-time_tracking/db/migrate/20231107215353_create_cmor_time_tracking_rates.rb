class CreateCmorTimeTrackingRates < ActiveRecord::Migration[7.1]
  def change
    create_table :cmor_time_tracking_rates do |t|
      t.string :identifier
      t.string :unit_name
      t.integer :unit_net_amount_cents
      t.integer :unit_tax_rate_percentage
      t.text :description

      t.timestamps
    end
  end
end
