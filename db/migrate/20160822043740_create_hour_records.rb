class CreateHourRecords < ActiveRecord::Migration
  def change
    create_table :hour_records do |t|
      t.references :activity, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.time :worked_hours
      t.date :worked_date
      t.text :description

      t.timestamps null: false
    end
  end
end
