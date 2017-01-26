# Records up to date information about repo
# rubocop:disable Metrics/MethodLength
class RepoInfoImporter
  def self.import(params, project_id)
    RepoInfo.create(
      description: params.fetch(:description),
      size: params.fetch(:size),
      watchers: params.fetch(:watchers),
      language: params.fetch(:language),
      forks: params.fetch(:forks_count),
      stars: params.fetch(:stargazers_count),
      repo_created_at: params.fetch(:created_at),
      repo_pushed_at: params.fetch(:pushed_at),
      repo_updated_at: params.fetch(:updated_at),
      project_id: project_id
    )
  end
  # rubocop:enable Metrics/MethodLength
end
