# Thin wrapper to allow Importer be called asynchronously by job queuing
# library (Sucker punch)
class ImporterWorker
  include SuckerPunch::Job
  def perform(slug)
    Importer.import(slug)
  end
end
