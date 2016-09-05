class AddWorkedHoursDecToHourRecord < ActiveRecord::Migration
  def change
    add_column :hour_records, :worked_hours_dec, :decimal, default: 0.0
  end
end
