# One place to request projects by slug (:owner/:repo)
#
# Gets the project from database, initiates import if necessary
class ProjectStore
  # Because the data request is not created in here, ProjectRequest abstracts
  # the information related to requesting project.
  #
  # Very similar to DataRequest, maybe an opportunity to refactor?
  class ProjectRequest
    attr_reader :project, :status

    def initialize(project, status)
      @project = project
      @status = status
    end
  end

  def self.get(slug)
    new(slug).get
  end

  def initialize(slug)
    @slug = slug
    @online = true
    @project = Project.by_slug(slug)
  end

  def get
    return existing_project_data if offline? || !can_import?

    if project_needs_import?
      trigger_import
      ProjectRequest.new(project, :in_progress)
    else
      ProjectRequest.new(project, :ready)
    end
  end

  def offline!
    @online = false
  end

  private

  attr_reader :slug, :project

  def existing_project_data
    if project.present?
      ProjectRequest.new(project, :ready)
    else
      ProjectRequest.new(nil, :error)
    end
  end

  def can_import?
    DataRequest.where(slug: slug).failed.created_after(1.hour.ago).count.zero?
  end

  def last_data_request
    DataRequest.where(slug: slug).order(updated_at: :desc).limit(1).first
  end

  def online?
    @online
  end

  def offline?
    !@online
  end

  def project_needs_import?
    project_out_of_date? && !import_in_progress?
  end

  def import_in_progress?
    DataRequest.where(slug: slug).first.try(:in_progress?)
  end

  def project_out_of_date?
    project.nil? || project.out_of_date?
  end

  def trigger_import
    ImporterWorker.perform_async(slug)
  end
end
