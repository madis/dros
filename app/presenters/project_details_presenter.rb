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

  def random_value
    rand(0..1000)
  end
end
