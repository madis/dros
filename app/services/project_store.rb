# One place to request projects by slug (:owner/:repo)
#
# Gets the project from database, initiates import if necessary
class ProjectStore
  UPDATE_FREQUENCY = 1.month

  def self.get(path)
    new(path, Importer).get
  end

  def initialize(path, importer)
    @path = path
    @importer = importer
  end

  def get
    project = Project.where(owner: owner, repo: repo).first
    if project.nil?
      project = Project.create(owner: owner, repo: repo)
      import_project(project)
    end
    update_when_out_of_date(project)
    project
  end

  private

  def import_project(project)
    @importer.import(project)
  end

  def update_when_out_of_date(project)
    import_project(project) if project.updated_at < Time.now - UPDATE_FREQUENCY
  end

  def owner
    path_components.first
  end

  def repo
    path_components.last
  end

  def path_components
    @path.split('/')
  end
end
