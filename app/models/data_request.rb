class DataRequest < ApplicationRecord
  enum status: [:created, :in_progress, :completed, :failed]
  belongs_to :project
  scope :created_after, ->(time) { where('created_at > ?', time) }
  scope :failed, -> { where(status: 'failed') }
end
