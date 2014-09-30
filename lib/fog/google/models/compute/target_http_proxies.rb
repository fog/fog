require 'fog/core/collection'
require 'fog/google/models/compute/target_http_proxy'

module Fog
  module Compute
    class Google
      class TargetHttpProxies < Fog::Collection
        model Fog::Compute::Google::TargetHttpProxy

        def all(filters={})
          data = service.list_target_http_proxies.body['items'] || []
          load(data)
        end

        def get(identity)
          response = service.get_target_http_proxy(identity)
          new(response.body) unless response.nil?
        end
      end
    end
  end
end
