class HomeController < ApplicationController

	def index
		@day_list = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Satursday", "Sunday"]
		@period_list = ["AM", "PM"]
		@moment_list = ["0-4", "4-8", "8-12"]
	end

	def update_selection_day
		session['day'] = params['selected_day']
		@day = session['day']
	end

	def update_selection_period
		session['period'] = params['selected_period']
		@period = session['period']
	end

	def update_selection_moment
		session['moment'] = params['selected_moment']
		@moment = session['moment']
		@period = session['period']
		@day = session['day']
		temp = 0
		@collection = [{:hour => "", :name =>"", :infos => ""}]
		split = []
		temp_collection = Planning.find :all
		if (temp_collection != [])
			temp_collection.each do |t|
				if (@period == "AM")
					@start_time_hour = @moment[0].to_int - 48
				else
					@start_time_hour = @moment[0].to_int - 36
				end
				if ((t.start_date.strftime("%A") == @day) and (t.start_date.strftime("%H") >= @start_time_hour.to_s) and (t.start_date.strftime("%H") < (@start_time_hour + 4).to_s))
					split = t.video.split("_")
					id_video = split[0]
					num_saison = split[1]
					num_eps = split[2]
					start_min = t.start_date.min.to_s
					if ((t.start_date.min.to_s).length < 2)
						start_min = "0" + t.start_date.min.to_s
					else
						start_min = t.start_date.min.to_s
					end
					start_hour = t.start_date.hour.to_s
					final_hour = start_hour + ":" + start_min + " "
					if ((num_saison == "0") and (num_eps == "0"))
						aux = Video.find(:all, :conditions => {:id => id_video})
						if (aux != [])
							@collection[temp] = {:hour => final_hour, :name => aux[0].name, :infos => aux[0].genre}
						else
							@collection[temp] = {:hour => "", :name => "No such video.", :infos => ""}
						end 
					else
						eps = Episode.find(:all, :conditions => {:serie => id_video, :season => num_saison, :episode_number => num_eps})
						if (eps != [])
							@collection[temp] = {:hour => final_hour, :name => aux[0].name + " ", :infos => eps[0].season.to_s + " " + eps[0].episode_number.to_s}
						else
							@collection[temp] = {:hour => "", :name => "No such eps.", :infos => ""}
						end
					end
					temp += 1
				end
			end
			@collection = @collection.sort_by {|res| res[:hour]}
		else
			@collection = [:hour => "", :name => "No video", :infos => ""]
		end
	end

end
