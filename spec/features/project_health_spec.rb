require 'rails_helper'

feature 'Project health' do
  scenario 'list of existing projects' do
    create(:project, health: 'excellent')
    create(:project, health: 'bad')
    visit '/projects'
    expect(page).to have_selector('table.projects tbody tr', count: 2)
  end
end
