require 'fog/core/collection'
require 'fog/brightbox/models/compute/cloud_ip'

module Fog
  module Compute
    class Brightbox

      class CloudIps < Fog::Collection

        model Fog::Compute::Brightbox::CloudIp

        def all
          data = service.list_cloud_ips
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.get_cloud_ip(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

        def allocate
          data = service.create_cloud_ip
          new(data)
        end

      end

    end
  end
end
