# Records up to date information about repo
class RepoInfoImporter
  def self.import(params, project_id)
    repo_info_params = {
      description: params.fetch(:description),
      size: params.fetch(:size),
      watchers: params.fetch(:watchers),
      language: params.fetch(:language),
      forks: params.fetch(:forks_count),
      stars: params.fetch(:stargazers_count),
      project_id: project_id
    }
    RepoInfo.create(repo_info_params)
  end
end
