class Video < ActiveRecord::Base  
  def self.get_all_names
    vids = self.find(:all, :select => :safe_name)
    names = []
    vids.each do |vid|
      names.push vid.safe_name
    end
    return names
  end
end
