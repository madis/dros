# Represents software project of associated github repository
class Project < ApplicationRecord
  has_many :contributions
  has_many :repo_infos
  has_one :stats

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

  def last_updated
    DataRequest.where(slug: slug, status: :completed).order(:updated_at).last.try(:updated_at)
  end

  def last_repo_info
    repo_infos.order(:created_at).last
  end

  def data_requests
    DataRequest.where(slug: slug)
  end

  def out_of_date?
    last_updated.nil? || last_updated < 1.week.ago
  end
end
