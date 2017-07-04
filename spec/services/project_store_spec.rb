require 'rails_helper'

RSpec.describe ProjectStore do
  subject { described_class.new('rails/rails').get }

  describe 'turning off external requests' do
    it 'does not import' do
      store = described_class.new('something/new')
      allow(Importer).to receive(:import)
      store.offline!
      store.get
      expect(Importer).to_not have_received(:import)
    end
  end

  context 'up to date data present in database' do
    it 'returns data' do
      project = create(:project, :up_to_date, owner: 'rails', repo: 'rails')
      expect(subject.project).to eq project
    end
  end

  context 'no data' do
    it 'initiates import' do
      allow(Importer).to receive(:import) { DataRequest.create(slug: 'rails/rails', status: :in_progress) }
      expect(subject.status).to eq :in_progress
      expect(subject.project).to be nil
      expect(Importer).to have_received(:import).with('rails/rails')
    end
  end

  context 'recent import failed' do
    it 'it shows error' do
      allow(Importer).to receive(:import).and_return(DataRequest.create(status: :failed, slug: 'rails/rails'))
      expect(subject.status).to eq :error
    end
  end

  context 'data outdated' do
    it 'returns existing and initiates update' do
      allow(Importer).to receive(:import)
      project = create(:project, owner: 'sala', repo: 'kala', updated_at: 1.year.ago)
      project_request = described_class.get('sala/kala')
      expect(project_request.project).to eq project
      expect(project_request.status).to eq :in_progress
      expect(Importer).to have_received(:import).with('sala/kala')
    end
  end

  context 'data import is in progress' do
    it 'does not start new one' do
      allow(Importer).to receive(:import) { create(:data_request, slug: 'rails/rails', status: 'in_progress') }
      described_class.get 'rails/rails'
      described_class.get 'rails/rails'
      expect(Importer).to have_received(:import).once
    end
  end
end
