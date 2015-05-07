class VideosController < ApplicationController

  def index
    @videos = Video.all
    @categories = Category.all
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end

  def show
    @video = Video.find(params[:id])
  end
end