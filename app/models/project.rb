# Represents software project of associated github repository
class Project < ApplicationRecord
  def slug
    "#{owner}/#{repo}"
  end
end
