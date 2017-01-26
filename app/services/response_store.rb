# Stores responses as backup in file names like:
# 2017-01-26-repository-madis_madis-4cc476778727f4443148bac671193f84d53324b9.json
#
# This can be useful when large amount of api responses needs to be played
# back to not exceed github api limits
class ResponseStore
  def self.store(data:, method: caller_locations[0].label, args:)
    new(data: data, method: method, args: args).store
  end

  def self.tmp_path
    File.expand_path('../../tmp', __dir__)
  end

  def initialize(data:, method:, args:)
    @data = data
    @method = method
    @args = args
  end

  def store
    FileUtils.mkdir_p response_root_path
    path = File.expand_path(file_name, response_root_path)
    File.open(path, 'w') { |f| f.write(pretty_json) }
    path
  end

  private

  attr_reader :data, :method, :args

  def file_name
    date = Time.now.strftime('%Y-%m-%d')
    args_slug = args.downcase.strip.tr(' ', '-').gsub(/[^\w-]/, '_')
    data_hash = Digest::SHA1.hexdigest(pretty_json)
    "#{date}-#{method}-#{args_slug}-#{data_hash}.json"
  end

  def pretty_json
    JSON.pretty_generate(JSON.parse(data.to_json))
  end

  def response_root_path
    File.expand_path('github_api_responses', tmp_path)
  end

  def tmp_path
    self.class.tmp_path
  end
end
