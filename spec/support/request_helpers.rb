module Requests
  module JsonHelpers
    def json_response
      JSON.parse(response.body).deep_symbolize_keys
    end
  end
end
