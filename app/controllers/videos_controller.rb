require 'extend_string'
require 'FileUtils'

class VideosController < ApplicationController
  # GET /videos
  # GET /videos.xml
  def index
    @videos = Video.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @videos }
    end
  end

  # GET /videos/1
  # GET /videos/1.xml
  def show
    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /videos/new
  # GET /videos/new.xml
  def new
    @video = Video.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @video }
    end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.xml
  def create
    @video = Video.new(params[:video])
    @video.safe_name = @video.name.urlize(:regexp => /[^A-Za-z0-9]/)
    if (params[:video][:is_film] == "1")
      file = params[:file]
      FileUtils.copy_file file.path, 'public/videos/films/' + @video.safe_name + '.flv'
    else
      FileUtils.mkdir('public/videos/series/' + @video.safe_name + '/')
    end

    respond_to do |format|
      if @video.save
        flash[:notice] = 'Video was successfully created.'
        format.html { redirect_to(@video) }
        format.xml  { render :xml => @video, :status => :created, :location => @video }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /videos/1
  # PUT /videos/1.xml
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      params[:video][:safe_name] = params[:video][:name].urlize(:regexp => /[^A-Za-z0-9]/)
      if @video.update_attributes(params[:video])
        flash[:notice] = 'Video was successfully updated.'
        format.html { redirect_to(@video) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @video.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /videos/1
  # DELETE /videos/1.xml
  def destroy
    @video = Video.find(params[:id])
    if @video.is_film
      file = 'public/videos/films/' + @video.safe_name + '.flv'
      if File.exists?(file)
        FileUtils.rm(file)
      end
    else
      dir = 'public/videos/series/' + @video.safe_name + '/'
      if File.directory?(dir)
        FileUtils.rmdir(dir)
      end
    end
    @video.destroy

    respond_to do |format|
      format.html { redirect_to(videos_url) }
      format.xml  { head :ok }
    end
  end

  def add_episode
    redirect_to :controller => 'episodes', :action => 'new', :id => params[:id]
  end
end