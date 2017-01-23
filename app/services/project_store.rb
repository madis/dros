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
  end

  def get
    if project_needs_import?
      trigger_import
      ProjectRequest.new(project, :in_progress)
    else
      ProjectRequest.new(project, :completed)
    end
  end

  private

  attr_reader :slug

  def project_needs_import?
    project_out_of_date? && !import_in_progress?
  end

  def import_in_progress?
    DataRequest.where(slug: slug).first.try(:in_progress?)
  end

  def project_out_of_date?
    project.nil? || project.out_of_date?
  end

  def project
    Project.by_slug(slug)
  end

  def trigger_import
    ImporterWorker.perform_async(slug)
  end
end
