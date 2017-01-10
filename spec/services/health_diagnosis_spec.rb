require 'spec_helper'
require 'services/health_diagnosis'

describe HealthDiagnosis do
  shared_examples :health_based_on_commit_activity do |expected_health|
    let(:global_stats) { OpenStruct.new(weekly_commits_per_contributor_med: 10) }

    it 'uses distance between min & max' do
      health = described_class.new(project_stats, global_stats).health
      expect(health).to be_within(1).of expected_health
    end
  end

  context 'active project' do
    let(:project_stats) { OpenStruct.new(weekly_commits_per_contributor_med: 9) }
    it_behaves_like :health_based_on_commit_activity, 90
  end

  context 'medium project' do
    let(:project_stats) { OpenStruct.new(weekly_commits_per_contributor_med: 5) }
    it_behaves_like :health_based_on_commit_activity, 50
  end

  context 'slow project' do
    let(:project_stats) { OpenStruct.new(weekly_commits_per_contributor_med: 1) }
    it_behaves_like :health_based_on_commit_activity, 10
  end
end
