require 'extend_string'
require 'FileUtils'

class EpisodesController < ApplicationController
  # GET /episodes
  # GET /episodes.xml
  def index
    @episodes = Episode.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @episodes }
    end
  end

  # GET /episodes/1
  # GET /episodes/1.xml
  def show
    @episode = Episode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @episode }
    end
  end

  # GET /episodes/new
  # GET /episodes/new.xml
  def new
    if (!Video.find(params[:id]).is_film)
      @episode = Episode.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @episode }
      end
    else
      redirect_to :controller => 'episodes'
    end
  end

  # GET /episodes/1/edit
  def edit
    if (!Video.find(params[:id]).is_film)
      @episode = Episode.find(params[:id])
    else
      redirect_to :controller => 'episodes'
    end
  end

  # POST /episodes
  # POST /episodes.xml
  def create
    @episode = Episode.new(params[:episode])
    @episode.safe_name = @episode.name.urlize(:regexp => /[^A-Za-z0-9]/)
    file = params[:file]
    dir = 'public/videos/series/' + Video.find(params[:episode][:serie]).safe_name +
      '/season' + params[:episode][:season] + '/'
    if !FileUtils.directory?(dir)
      FileUtils.mkdir(dir)
    end
    FileUtils.copy file.path, dir + 'episode' + params[:episode][:episode_number] + '.flv'

    respond_to do |format|
      if @episode.save
        flash[:notice] = 'Episode was successfully created.'
        format.html { redirect_to :controller => 'videos', :action => 'show', :id => params[:episode][:serie] }
        format.xml  { render :xml => @episode, :status => :created, :location => @episode }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @episode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /episodes/1
  # PUT /episodes/1.xml
  def update
    @episode = Episode.find(params[:id])

    respond_to do |format|
      if @episode.update_attributes(params[:episode])
        flash[:notice] = 'Episode was successfully updated.'
        format.html { redirect_to :controller => 'videos', :action => 'show', :id => params[:episode][:serie] }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @episode.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /episodes/1
  # DELETE /episodes/1.xml
  def destroy
    @episode = Episode.find(params[:id])
    file = 'public/videos/series/' + Video.find(@episode.serie).safe_name +
      '/season' + @episode.season.to_s + '/episode' + @episode.episode_number.to_s + '.flv'
    if FileUtils.exists?(file)
      FileUtils.delete file
    end
    dir = 'public/videos/series/' + Video.find(@episode.serie).safe_name +
      '/season' + @episode.season.to_s + '/'
    if FileUtils.entries(dir).length - 2 == 0 #-2 to exclude "." and ".."
      FileUtils.rmdir(dir)
    end
    @episode.destroy
    
    respond_to do |format|
      format.html { redirect_to(episodes_url) }
      format.xml  { head :ok }
    end
  end
end