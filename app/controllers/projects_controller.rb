class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def slug
    @project = ProjectStore.get "#{params[:owner]}/#{params[:repo]}"
    render :show
  end
end
