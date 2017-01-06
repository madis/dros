require 'rails_helper'

RSpec.describe Importer do
  let(:project) { Project.create(owner: 'vuejs', repo: 'vue') }
  subject { described_class.import(project) }

  before do
    allow(GithubApi).to receive(:contributors_stats).and_return(json_fixture('repo_stats_vuejs_vue.json'))
  end

  it 'updates project status' do
    expect { subject }.to change { project.health }.from('unknown').to('excellent')
  end

  it 'updates contributions' do
    expect { subject }.to change { project.contributions.count }.by 39
  end

  it 'does not add empty contributions' do
    subject
    expect(Contribution.where(commits: 0, additions: 0, deletions: 0).count).to eq 0
  end
end
