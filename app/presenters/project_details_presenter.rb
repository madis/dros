# Preparing data for project details view
#
# Currently hardcoded and random values for preparing the view
class ProjectDetailsPresenter < ProjectPresenter
  def metrics
    [
      'Contribution frequency',
      'Contributions per user',
      'Contributions owner vs others',
      'Open issues',
      'Solved issues',
      'Average issue solving time',
      'Issues vs pull requests',
      'Test situation'
    ]
  end

  def health_assessments
    labels = Date::MONTHNAMES.compact.map { |n| n[0..2] }
    {
      labels: labels,
      series: [(1..labels.size).map { rand(100) }]
    }
  end

  def health_change
    44
  end

  def last_updated
    @project.updated_at
  end

  def random_value
    rand(0..1000)
  end
end
