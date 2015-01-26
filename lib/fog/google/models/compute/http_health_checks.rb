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
          resonse = nil
          response = service.get_http_health_check(identity)
          return nil if response.nil?
          new(response.body)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
