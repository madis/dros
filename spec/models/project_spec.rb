require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { create(:project, owner: 'rails', repo: 'rails') }
  describe '#slug' do
    subject { project.slug }
    it { is_expected.to eq 'rails/rails' }
  end

  describe '#last_updated' do
    it 'has date of latest completed data request' do
      create(:data_request, slug: 'hello/world', status: :completed, updated_at: 2.days.ago)
      create(:data_request, slug: 'hello/world', status: :completed, updated_at: 1.day.ago)
      create(:data_request, slug: 'hello/world', status: :in_progress, updated_at: 1.minute.ago)

      project = create(:project, owner: 'hello', repo: 'world')

      expect(project.last_updated).to be_within(1.second).of 1.days.ago
    end
  end

  describe '#out_of_date?' do
    it 'true when last updated more than week ago' do
      create(:data_request, slug: 'hello/world', status: :completed, updated_at: 1.week.ago - 1.hour)

      project = create(:project, owner: 'hello', repo: 'world')
      expect(project.out_of_date?).to be true
    end

    it 'false when last updated more than week ago' do
      create(:data_request, slug: 'hello/world', status: :completed, updated_at: 5.days.ago)
      create(:data_request, slug: 'hello/world', status: :in_progress, updated_at: 1.minute.ago)

      project = create(:project, owner: 'hello', repo: 'world')
      expect(project.out_of_date?).to be false
    end
  end
end
