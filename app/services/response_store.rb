# Stores responses as backup in file names like:
# 2017-01-26-repository-madis_madis-4cc476778727f4443148bac671193f84d53324b9.json
#
# This can be useful when large amount of api responses needs to be played
# back to not exceed github api limits
class ResponseStore
  def self.store(data:, method: caller_locations[0].label, args:)
    new(method: method, args: args).store(data)
  end

  def self.retrieve(method: caller_locations[0].label, args:)
    new(method: method, args: args).retrieve
  end

  def self.tmp_path
    File.expand_path('../../tmp', __dir__)
  end

  def initialize(method:, args:)
    @method = method
    @args = args
  end

  # Returns the latest data for method & args
  def retrieve
    read_as_json most_recent matching_files
  end

  def store(data)
    FileUtils.mkdir_p response_root_path
    path = File.expand_path(file_name(data), response_root_path)
    File.open(path, 'w') { |f| f.write(data_to_json(data)) }
    path
  end

  private

  attr_reader :method, :args

  def matching_files
    Dir["#{response_root_path}/*#{static_file_name_part}*.json"]
  end

  def most_recent(paths)
    return if paths.empty?
    paths
      .map { |p| { path: p, date: date_from_file_name(p) } }
      .sort_by { |f| f[:date] }
      .last[:path]
  end

  def read_as_json(path)
    return if path.nil?
    JSON.parse(File.read(path))
  end

  def date_from_file_name(path)
    date_string = Pathname.new(path).basename.to_s.match(/^\d{4}-\d{2}-\d{2}/).to_s
    Date.parse(date_string)
  end

  def file_name(data)
    date = Time.now.strftime('%Y-%m-%d')
    data_hash = Digest::SHA1.hexdigest(data_to_json(data))
    "#{date}-#{static_file_name_part}-#{data_hash}.json"
  end

  def static_file_name_part
    args_slug = args.to_s.downcase.strip.tr(' ', '-').gsub(/[^\w-]/, '_')
    "#{method}-#{args_slug}"
  end

  def data_to_json(data)
    if data.is_a?(Array)
      data.map(&:to_h).to_json
    else
      data.to_json
    end
  end

  def response_root_path
    File.expand_path('github_api_responses', tmp_path)
  end

  def tmp_path
    self.class.tmp_path
  end
end
