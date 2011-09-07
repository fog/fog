require 'fog/core/collection'
require 'fog/brightbox/models/compute/cloud_ip'

module Fog
  module Compute
    class Brightbox

      class CloudIps < Fog::Collection

        model Fog::Compute::Brightbox::CloudIp

        def all
          data = connection.list_cloud_ips
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = connection.get_cloud_ip(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

        def allocate
          data = connection.create_cloud_ip
          new(data)
        end

      end

    end
  end
end