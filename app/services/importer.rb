# Updates project data from external sources, based on DataRequests
class Importer
  def self.import(data_request)
    new(data_request).import
  end

  def initialize(data_request)
    @data_request = data_request
  end

  def import
    project = find_or_create_project
    import_data(project)
    update_stats(project)
    update_health(project)
    data_request.completed!
  rescue GithubApi::NotFound
    data_request.failed!
  end

  private

  attr_reader :data_request

  def find_or_create_project
    project = Project.by_slug(slug)
    return project if project.present?
    Project.from_slug slug
  end

  def project_info
    params.merge(owner_avatar_url: repo.dig(:owner, :avatar_url))
  end

  def import_data(project)
    ContributionsImporter.import GithubApi.contributors_stats(slug), project.id
    RepoInfoImporter.import GithubApi.repo(slug), project.id
  end

  def update_stats(project)
    StatsUpdater.update(project)
  end

  def update_health(project)
    project.update_attributes(
      health: HealthDiagnosis.new(ProjectStats.find_by(project: project), ProjectStats.global).health
    )
  end

  def slug
    @data_request.slug
  end
end
