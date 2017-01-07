require_relative '../services/normalized_value'

# Interface for displaying project model in the UI
class ProjectPresenter
  HEALTH_RATINGS = %w(
    bad
    weak
    ok
    great
    excellent
  ).freeze

  ICON_TEXTS = %w(
    very_dissatisfied
    dissatisfied
    neutral
    satisfied
    very_satisfied
  ).freeze

  ICON_COLORS = %w(red orange green).freeze

  MAX_PROJECT_HEALTH = 100

  attr_reader :project

  delegate :owner, :repo, :slug, to: :@project

  def initialize(project)
    @project = project
  end

  def url
    "https://github.com/#{slug}"
  end

  def description
    "Description for #{project.slug} comes here"
  end

  def health
    NormalizedValue.pick(HEALTH_RATINGS, project.health, MAX_PROJECT_HEALTH)
  end

  def icon_text
    icon_text = NormalizedValue.pick(ICON_TEXTS, project.health, MAX_PROJECT_HEALTH)
    "sentiment_#{icon_text}"
  end

  def icon_color
    NormalizedValue.pick(ICON_COLORS, project.health, MAX_PROJECT_HEALTH)
  end
end
