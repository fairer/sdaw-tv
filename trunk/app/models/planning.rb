class Planning < ActiveRecord::Base
  validates_presence_of :video

  def self.get_currently_playing
    last_vid = self.find :last, :order => 'start_date'
    if last_vid != nil
      id = (last_vid.video.split '_')[0]
      season = (last_vid.video.split '_')[1]
      episode_num = (last_vid.video.split '_')[2]
      vid = Video.find id
      if !vid.is_film
        episode = Episode.find_by_episode_number_and_season episode_num, season
      end
      date = last_vid.start_date.utc
      now = Time.now.utc
      seek = (now - date)
      if seek > (vid.average_episode_duration) || seek < 0
        return nil
      else
        return {:video => vid, :episode => episode, :start_date => date, :seek => seek}
      end
    else
      return nil
    end
  end

  def self.get_ad
    entries = Dir.entries('public/videos/ads/')
    ads = Array.new
    entries.each do |e|
      if e.split('')[0] != '.'
        ads.push e
      end
    end
    return ads[rand(ads.length)]
  end
end
