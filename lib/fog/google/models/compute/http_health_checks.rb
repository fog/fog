require 'fog/core/collection'
require 'fog/google/models/compute/http_health_check'

module Fog
  module Compute
    class Google
      class HttpHealthChecks < Fog::Collection
        model Fog::Compute::Google::HttpHealthCheck

        def all(filters={})
          data = service.list_http_health_checks.body['items'] || []
          load(data)
        end

        def get(identity)
          response = service.get_http_health_check(identity)
          new(response.body) unless response.nil?
        end
      end
    end
  end
end
