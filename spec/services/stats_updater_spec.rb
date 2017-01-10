require 'rails_helper'

describe StatsUpdater do
  it 'updates' do
    project = create(:project)
    create(:contribution, project: project, commits: 0)
    create(:contribution, project: project, commits: 10)
    create(:contribution, project: project, commits: 30)
    create(:contribution, project: project, commits: 30)
    create(:contribution, project: project, commits: 40)

    described_class.update(project)

    expect(ProjectStats.last).to have_attributes(
      weekly_commits_per_contributor_min: 0.0,
      weekly_commits_per_contributor_max: 40.0,
      weekly_commits_per_contributor_avg: 22.0,
      weekly_commits_per_contributor_med: 30.0
    )
  end
end
