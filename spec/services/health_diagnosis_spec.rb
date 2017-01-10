require 'spec_helper'
require 'services/health_diagnosis'

describe HealthDiagnosis do
  context 'active repository' do
    it 'has high score' do
      project_stats = { weekly_commits: BasicStats.new([10]) }
      global_stats = { weekly_commits: BasicStats.new([5]) }
      health = described_class.new(project_stats, global_stats).health
      expect(health).to be_within(1).of 100
    end
  end
end
