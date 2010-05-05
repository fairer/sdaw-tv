class CommentsController < ApplicationController
  before_filter :authenticate, :except => [:index, :create, :show]

  # GET /comments
  # GET /comments.xml
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end
  
  # GET /comments/1
  # GET /comments/1.xml
  def show
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end

  # POST /comments
  # POST /comments.xml
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(params[:comment])
    respond_to do |format|
      format.html { redirect_to @post}
      format.js
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @post = Post.find(params[:post_id])
    @post.comments.destroy(params[:comment])
    respond_to do |format|
      format.html { redirect_to @post}
      format.js
    end
  end

private

  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      name == "admin" && password == "sdaw"
    end
  end
end
