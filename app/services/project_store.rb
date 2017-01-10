# One place to request projects by slug (:owner/:repo)
#
# Gets the project from database, initiates import if necessary
class ProjectStore
  def self.get(slug)
    new(slug, Importer).get
  end

  def initialize(slug, importer)
    @slug = slug
    @importer = importer
  end

  def get
    if project.nil?
      trigger_import(slug)
    else
      update_when_out_of_date(project)
    end
    project
  end

  private

  attr_reader :slug

  def project
    Project.by_slug(slug)
  end

  def trigger_import(slug)
    data_request = DataRequest.create slug: slug
    @importer.import(data_request)
  end

  def update_when_out_of_date(project)
    trigger_import(project.slug) if project.out_of_date?
  end
end
