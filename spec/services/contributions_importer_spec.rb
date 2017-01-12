require 'rails_helper'

describe ContributionsImporter do
  it 're-importing same file does not increase contributions count' do
    project = create(:project)
    described_class.import(json_fixture('repo_stats_vuejs_vue.json'), project.id)
    expect(Contribution.count).to eq 39
    described_class.import(json_fixture('repo_stats_vuejs_vue.json'), project.id)
    expect(Contribution.count).to eq 39
  end
end
