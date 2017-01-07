require 'presenters/project_presenter'

RSpec.describe ProjectPresenter do
  describe '#icon_text' do
    let(:project) { double('project', health: health) }
    subject { described_class.new(project).icon_text }

    context 'health 0..20' do
      let(:health) { 8 }
      it { is_expected.to eq 'sentiment_very_dissatisfied' }
    end

    context 'health 21..40' do
      let(:health) { 35 }
      it { is_expected.to eq 'sentiment_dissatisfied' }
    end

    context 'health 41..60' do
      let(:health) { 55 }
      it { is_expected.to eq 'sentiment_neutral' }
    end

    context 'health 61..80' do
      let(:health) { 75 }
      it { is_expected.to eq 'sentiment_satisfied' }
    end

    context 'health 81..100' do
      let(:health) { 90 }
      it { is_expected.to eq 'sentiment_very_satisfied' }
    end
  end
end
