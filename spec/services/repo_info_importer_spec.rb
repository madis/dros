require 'rails_helper'

describe RepoInfoImporter do
  it 'creates record in the database' do
    project = create(:project)
    described_class.import json_fixture('repo_info_vuejs_vue.json'), project.id
    expect(RepoInfo.last).to have_attributes(
      description: 'A progressive, incrementally-adoptable JavaScript framework for building UI on the web.',
      size: 16_230,
      watchers: 39_124,
      language: 'JavaScript',
      forks: 4797,
      stars: 39_124
    )
  end
end
