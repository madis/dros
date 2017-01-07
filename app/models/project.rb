# Represents software project of associated github repository
class Project < ApplicationRecord
  has_many :contributions

  def slug
    "#{owner}/#{repo}"
  end
end
