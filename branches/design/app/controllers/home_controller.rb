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
		session['temp'] = 1
		session['collection'] = [{:name => "kikoo"}, {:name => "lol"}]
	end

end
