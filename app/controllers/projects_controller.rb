class ProjectsController < ApplicationController
  def index
    @projects = Project.all.map { |p| ProjectPresenter.new(p) }
  end

  def show_slug
    project_request = ProjectStore.get(slug)
    case project_request.status
    when :completed
      show_project_details(project_request.project)
    when :in_progress
      show_in_progress_notification
    when :error
      show_project_not_found_error
    end
  end

  private

  def slug
    "#{params[:owner]}/#{params[:repo]}"
  end

  def show_project_details(project)
    @project = ProjectDetailsPresenter.new project
    render :show, status: :ok
  end

  def show_in_progress_notification
    flash.now[:notice] = "Data for #{slug} is being prepared"
    render :in_progress, status: :accepted
  end

  def show_project_not_found_error
    flash.now[:error] = "Could not find project for #{slug}"
    render :error, :not_found
  end
end
