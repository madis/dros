class AddNullConstraintsForProjects < ActiveRecord::Migration[5.0]
  class Project < ActiveRecord::Base; end

  def change
    Project.all.each { |p| p.update_attributes health: 'unknown' if p.health.blank? }
    change_column_null :projects, :owner, false
    change_column_null :projects, :repo, false
    change_column_null :projects, :health, false
    change_column_default :projects, :health, 'unknown'
  end
end
