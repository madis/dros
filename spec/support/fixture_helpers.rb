module FixtureHelpers
  def fixture(name)
    File.read File.expand_path("../fixtures/#{name}", File.dirname(__FILE__))
  end

  def json_fixture(name)
    res = JSON.parse(fixture(name))
    if res.is_a? Array
      res.map(&:deep_symbolize_keys)
    else
      res.deep_symbolize_keys
    end
  end
end
