class DataRequest < ApplicationRecord
  enum status: [:created, :in_progress, :completed, :failed]
end
