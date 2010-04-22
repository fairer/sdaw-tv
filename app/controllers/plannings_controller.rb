class PlanningsController < ApplicationController
  layout "plannings"

  def get_next
    @next = Planning.find_all_by_start_date('42')

    render :xml => @next
  end

  def new
    @video = Planning.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @video }
      end
  end

  def create
    @video = Planning.new(params[:planning])

    respond_to do |format|
      if @video.save
        flash[:notice] = 'Video was successfully added to playlist.'
        format.html { render :controller => 'home', :action => 'index' }
        format.xml  { render :xml => @video, :status => :created, :location => @video }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

end
