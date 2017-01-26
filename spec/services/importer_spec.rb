require 'rails_helper'

RSpec.describe Importer do
  let(:slug) { 'vuejs/vue' }
  subject { described_class.import(slug) }

  before do
    allow(GithubApi).to receive(:contributors_stats).and_return(json_fixture('repo_stats_vuejs_vue.json'))
    allow(GithubApi).to receive(:repo).and_return(json_fixture('repo_info_vuejs_vue.json'))
  end

  it 'updates project status' do
    subject
    project = Project.by_slug(slug)
    expect(project.health).to be > 50
  end

  it 'updates contributions' do
    subject
    project = Project.by_slug(slug)
    expect(project.contributions.count).to eq 39
  end

  it 'does not add empty contributions' do
    subject
    expect(Contribution.where(commits: 0, additions: 0, deletions: 0).count).to eq 0
  end

  it 'adds project info' do
    subject
    project = Project.by_slug(slug)
    expect(project.repo_info).to have_attributes(
      description: 'A progressive, incrementally-adoptable JavaScript framework for building UI on the web.',
      size: 16_230,
      watchers: 39_124,
      language: 'JavaScript'
    )
  end

  it 'completes data request' do
    subject
    data_request = DataRequest.last
    expect(data_request).to be_completed
  end
end
