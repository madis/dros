require 'rails_helper'

feature 'User views project health' do
  scenario 'list of existing projects' do
    create(:project, health: 90)
    create(:project, health: 10)
    visit '/projects'
    expect(page).to have_selector('.project-cell', count: 2)
  end

  scenario 'requesting project that is up to date in the database' do
    fake_project_store_with 'vuejs/vue'
    visit 'vuejs/vue'
    expect(page).to have_link 'vuejs/vue', href: 'https://github.com/vuejs/vue'
    expect(page).to have_css '.material-icons', text: 'sentiment_very_satisfied'
  end

  scenario 'requesting unknown project takes time' do
    allow(GithubApi).to receive(:contributors_stats) do
      json_fixture('repo_stats_vuejs_vue.json')
    end
    allow(GithubApi).to receive(:repo).and_return(json_fixture('repo_info_vuejs_vue.json'))

    visit 'vuejs/vue'
    expect(page).to have_css '.alert-info', text: 'Data for vuejs/vue is being prepared'
    expect(page).to have_http_status(202)
    check = -> { page.has_link?('Refresh') }
    action = -> { click_on 'Refresh' }
    do_until(check, action)
    expect(page).to have_css 'table.metrics'
  end

  def do_until(check, action)
    action.call while check.call == true
  end

  def fake_project_store_with(slug)
    project = create(:project, owner: 'vuejs', repo: 'vue', health: 95)
    project_request = ProjectStore::ProjectRequest.new(project, :completed)
    allow(ProjectStore).to receive(:get).with(slug).and_return project_request
  end
end
