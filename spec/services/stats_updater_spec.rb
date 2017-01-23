require 'rails_helper'

describe StatsUpdater do
  it 'updates' do
    project = create(:project)
    create_weekly_contributions(project, 'a', [10, 20, 30])
    create_weekly_contributions(project, 'b', [0, 10, 50])

    described_class.update(project)

    expect(ProjectStats.last).to have_attributes(
      weekly_commits_per_contributor_min: 0.0,
      weekly_commits_per_contributor_max: 50.0,
      weekly_commits_per_contributor_avg: 20,
      weekly_commits_per_contributor_med: 15.0
    )
  end

  def create_weekly_contributions(project, author, contributions)
    contributions.each.with_index do |c, i|
      week_start = Time.now - (contributions.count - i).weeks
      create(:contribution, week: week_start, project: project, author: author, commits: c)
    end
  end
end
