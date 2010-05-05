class Video < ActiveRecord::Base
  def self.get_all_names
    vids = self.find(:all, :select => :name)
    names = []
    vids.each do |vid|
      names.push vid.name
    end
    return names
  end
end
