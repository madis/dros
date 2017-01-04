require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { create(:project, owner: 'rails', repo: 'rails') }
  describe '#slug' do
    subject { project.slug }
    it { is_expected.to eq 'rails/rails' }
  end
end
