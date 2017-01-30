class AddProjectIdToDataRequests < ActiveRecord::Migration[5.0]
  def up
    add_reference :data_requests, :project, foreign_key: true

    DataRequest.all.each do |dr|
      project = Project.by_slug(dr.slug)
      puts "Adding foreign key from data request '#{dr.slug}' #{dr.id} to project #{project.id}"
      dr.project_id = project.id
      dr.save
    end
  end

  def down
    remove_reference :data_requests, :project, index: true, foreign_key: true
  end
end
