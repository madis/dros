class GithubApi
  # Wrapper around github repository search
  #
  # - returns enumerator allowing iteration over different pages
  # - caches results, allowing faster enumeration of results
  # - limits enumerator size to github max search limit
  class SearchRepositories
    PER_PAGE = 100
    GITHUB_MAX_SEARCH_RESULTS = 1000

    def self.call(min_stars)
      new(min_stars, GithubApi.octokit).call
    end

    def initialize(min_stars, octokit)
      @min_stars = min_stars
      @octokit = octokit
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def call
      first_page = octokit.search_repositories(search_term, search_params)
      total_result_count = first_page[:total_count]
      cached_pages = []
      cached_pages << first_page
      Enumerator.new(total_result_count) do |yielder|
        current_page = 1
        first_page[:items].each { |i| yielder.yield i }
        yielded_result_count = first_page[:items].count

        loop do
          current_page += 1
          break if would_go_beyond_last_page?(current_page, total_result_count)
          if current_page > cached_pages.count
            next_page = octokit.search_repositories(search_term, search_params.merge(page: current_page))
            cached_pages << next_page
            cached_pages[current_page - 1][:items].each { |i| yielder.yield i }
            yielded_result_count += next_page[:items].count
          else
            cached_pages[current_page - 1][:items].each { |i| yielder.yield i }
          end
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    private

    attr_reader :min_stars, :octokit

    def search_params
      { per_page: PER_PAGE }
    end

    def search_term
      "stars:>#{min_stars}"
    end

    def would_go_beyond_last_page?(wanted_page, total)
      last_page = (total - 1) / PER_PAGE + 1
      wanted_page > last_page || wanted_page * PER_PAGE > GITHUB_MAX_SEARCH_RESULTS
    end
  end
end
