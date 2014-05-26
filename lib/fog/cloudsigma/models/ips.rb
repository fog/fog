require 'fog/core/collection'
require 'fog/cloudsigma/models/ip'

module Fog
  module Compute
    class CloudSigma
      class Ips < Fog::Collection
        model Fog::Compute::CloudSigma::IP

        def all
          resp = service.list_ips
          data = resp.body['objects']
          load(data)
        end

        def get(ip)
          resp = service.get_ip(ip)
          data = resp.body
          new(data)
        rescue Fog::CloudSigma::Errors::NotFound
          return nil
        end
      end
    end
  end
end
