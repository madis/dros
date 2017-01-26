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
      stars: 39_124,
      repo_created_at: Time.parse('2013-07-29 03:24:51.000000000 +0000'),
      repo_pushed_at: Time.parse('2017-01-10 07:42:56.000000000 +0000'),
      repo_updated_at: Time.parse('2017-01-10 09:06:52.000000000 +0000')
    )
  end
end
