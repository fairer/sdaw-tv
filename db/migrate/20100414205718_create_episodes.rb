class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.string :name
      t.integer :episode_number
      t.integer :season
      t.integer :serie
      t.text :tags
      t.text :description
      t.int :duration

      t.timestamps
    end
  end

  def self.down
    drop_table :episodes
  end
end
