# Records up to date information about repo
class RepoInfoImporter
  def self.import(params, project_id)
    repo_info_params = {
      description: params.fetch(:description),
      size: params.fetch(:size),
      watchers: params.fetch(:watchers),
      language: params.fetch(:language),
      project_id: project_id
    }
    RepoInfo.create(repo_info_params)
  end
end
