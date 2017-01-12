require 'rails_helper'

RSpec.describe ProjectStore do
  let(:importer) { double(Importer) }
  subject { described_class.new('rails/rails', importer).get }

  context 'up to date data present in database' do
    it 'returns data' do
      project = create(:project, :up_to_date, owner: 'rails', repo: 'rails')
      expect(subject).to eq project
    end
  end

  context 'no data' do
    it 'initiates import' do
      allow(importer).to receive(:import)
      expect(subject).to eq nil
      expect(importer).to have_received(:import).with('rails/rails')
    end
  end

  context 'data outdated' do
    it 'returns existing and initiates update' do
      allow(Importer).to receive(:import)
      project = create(:project, owner: 'sala', repo: 'kala', updated_at: 1.year.ago)
      expect(described_class.get('sala/kala')).to eq project
      expect(Importer).to have_received(:import).with('sala/kala')
    end
  end
end
