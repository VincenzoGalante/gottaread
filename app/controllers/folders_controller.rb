class FoldersController < ApplicationController
  def index
    @folders = Folder.all
  end

  def new
    @folder = Folder.new
  end

  def create
    @folder = Folder.new(folders_params)
    @folder.user = current_user
      if @folder.save
        redirect_to root_path
      else
        render :new
      raise
      end
  end

  private

  def folders_params
    params.require(:folder).permit(:title, :description, :image, :color)
  end
end