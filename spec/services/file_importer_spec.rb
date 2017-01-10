# class ProjectFinder
#   LANGUAGES = %w(ruby php javascript clojure swift objective-c).freeze

#   def find
#     LANGUAGES.flat_map do |lang|
#       repos_for_language(lang)
#     end
#   end

#   private

#   def repos_for_language(language)
#     [
#       GithubRepoSearch.find(language: language, stars: '>=500', sort: 'stars'),
#       GithubTrending.today(language: language),
#       GithubTrending.weekly(language: language),
#       GithubTrending.monthly(language: language)
#     ]
#   end
# end

# describe MultiImporter do
#   it 'imports repos from list' do
#   end
# end
