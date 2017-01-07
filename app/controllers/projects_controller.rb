class ProjectsController < ApplicationController
  def index
    @projects = Project.all.map { |p| ProjectPresenter.new(p) }
  end

  def slug
    @project = ProjectPresenter.new ProjectStore.get("#{params[:owner]}/#{params[:repo]}")
    render :show
  end
end
