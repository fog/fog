require 'fog/core/collection'
require 'fog/brightbox/models/compute/cloud_ip'

module Fog
  module Brightbox
    class Compute

      class CloudIps < Fog::Collection

        model Fog::Brightbox::Compute::CloudIp

        def all
          data = JSON.parse(connection.list_cloud_ips.body)
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = JSON.parse(connection.get_cloud_ip(identifier).body)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

        def allocate
          data = JSON.parse(connection.create_cloud_ip.body)
          new(data)
        end

      end

    end
  end
end