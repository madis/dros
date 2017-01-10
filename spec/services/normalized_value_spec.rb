require 'spec_helper'

require 'services/normalized_value'

RSpec.describe NormalizedValue do
  describe '.pick' do
    subject { described_class.pick %i(low medium high), source_value, 100 }

    context 'low' do
      let(:source_value) { 10 }
      it { is_expected.to eq :low }
    end

    context 'medium' do
      let(:source_value) { 50 }
      it { is_expected.to eq :medium }
    end

    context 'high' do
      let(:source_value) { 100 }
      it { is_expected.to eq :high }
    end
  end
end
