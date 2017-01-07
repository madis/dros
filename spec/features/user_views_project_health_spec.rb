require 'rails_helper'

feature 'User views project health' do
  scenario 'list of existing projects' do
    create(:project, health: 90)
    create(:project, health: 10)
    visit '/projects'
    expect(page).to have_selector('.project-cell', count: 2)
  end

  scenario 'requesting specific project' do
    allow(GithubApi).to receive(:contributors_stats).and_return(json_fixture('repo_stats_vuejs_vue.json'))
    visit 'vuejs/vue'

    expect(page).to have_link 'vuejs/vue', href: 'https://github.com/vuejs/vue'
    expect(page).to have_css '.project-health', text: 'great'
  end
end
