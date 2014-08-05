require 'fog/core/collection'
require 'fog/xenserver/models/compute/vlan'

module Fog
  module Compute
    class XenServer
      class Vlans < Fog::Collection
        model Fog::Compute::XenServer::VLAN

        # Return the list of VLANs available
        #
        # @return [Array] a list of Fog::Compute::XenServer::VLAN
        #
        def all(options = {})
          data = service.get_records 'VLAN'
          load(data)
        end

        # Retrieve a VLAN object by by reference.
        #
        # @return [Fog::Compute::XenServer::VLAN]
        #
        # Returns nil if not found
        #
        def get( ref )
          if ref && obj = service.get_record( ref, 'VLAN' )
            new(obj)
          end
        rescue Fog::XenServer::NotFound
          nil
        end
      end
    end
  end
end
