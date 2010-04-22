class CreatePlannings < ActiveRecord::Migration
  def self.up
    create_table :plannings do |t|
      t.integer :video
      t.timestamp :start_date

      t.timestamps
    end
  end

  def self.down
    drop_table :plannings
  end
end
