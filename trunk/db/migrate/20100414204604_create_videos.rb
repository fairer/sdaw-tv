class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :name
      t.string :safe_name
      t.text :tags
      t.integer :nb_seasons
      t.integer :average_episode_duration
      t.text :desc
      t.string :genre

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
