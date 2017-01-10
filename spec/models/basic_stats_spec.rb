require 'spec_helper'
require 'models/basic_stats'

describe BasicStats do
  subject { described_class.new }

  it 'takes values through initializer' do
    stats = described_class.new [1, 2, 3]
    expect(stats.max).to eq 3
  end

  describe '#min' do
    it 'smaller of values' do
      stats = described_class.new [1, 2]
      expect(stats.min).to eq 1
    end

    it 'is up to date after new values' do
      stats = described_class.new [100]
      expect((stats << -100).min).to eq(-100)
    end
  end

  describe '#max' do
    it 'bigger of values' do
      stats = described_class.new [1, 2]
      expect(stats.max).to eq 2
    end

    it 'is up to date after new values' do
      stats = described_class.new [-100]
      expect((stats << 100).max).to eq 100
    end
  end

  describe '#avg' do
    it 'average of values' do
      stats = described_class.new [1, 2]
      expect(stats.avg).to be_within(0.001).of(1.5)
    end
  end

  describe '#med' do
    it 'common of values (even lentght)' do
      stats = described_class.new [1, 2, 2, 3]
      expect(stats.med).to be_within(0.001).of(2)
    end

    it 'common of values (odd lentght)' do
      stats = described_class.new [1, 2, 2]
      expect(stats.med).to be_within(0.001).of(2)
    end
  end
end
