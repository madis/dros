# Represents software project of associated github repository
class Project < ApplicationRecord
  has_many :contributions
  has_one :repo_info
  has_one :stats
  has_many :data_requests

  def self.from_slug(slug)
    slug_components = slug.split('/')
    owner = slug_components.first
    repo = slug_components.last
    create(owner: owner, repo: repo)
  end

  def self.by_slug(slug)
    slug_components = slug.split('/')
    owner = slug_components.first
    repo = slug_components.last
    find_by(owner: owner, repo: repo)
  end

  def slug
    "#{owner}/#{repo}"
  end

  def last_data_request
    DataRequest.where(slug: slug, status: :completed).order(:updated_at).last
  end

  def last_updated
    last_data_request.try(:updated_at)
  end

  def data_requests
    DataRequest.where(slug: slug)
  end

  def out_of_date?
    last_updated.nil? || last_updated < 1.week.ago
  end
end
