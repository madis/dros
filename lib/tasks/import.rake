namespace :import do
  def import_project(slug)
    puts "Importing #{slug}"
    Importer.import slug
  end

  task examples: :environment do
    EXAMPLES = %w(
      madis/dros
      rails/rails
      vuejs/vue
    ).freeze

    EXAMPLES.each { |s| import_project s }
  end

  task trending: :environment do
    GithubTrending.weekly.each { |t| import_project t[:slug] }
  end
end
