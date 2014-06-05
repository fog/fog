require 'fog/core/collection'
require 'fog/cloudsigma/models/vlan'

module Fog
  module Compute
    class CloudSigma
      class Vlans < Fog::Collection
        model Fog::Compute::CloudSigma::VLAN

        def all
          resp = service.list_vlans
          data = resp.body['objects']
          load(data)
        end

        def get(vlan)
          resp = service.get_vlan(vlan)
          data = resp.body
          new(data)
        rescue Fog::CloudSigma::Errors::NotFound
          return nil
        end
      end
    end
  end
end
