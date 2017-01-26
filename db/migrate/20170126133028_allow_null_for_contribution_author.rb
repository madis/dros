class AllowNullForContributionAuthor < ActiveRecord::Migration[5.0]
  def change
    change_column_null :contributions, :author, true
  end
end
