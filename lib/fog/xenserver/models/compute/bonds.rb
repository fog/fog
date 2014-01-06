require 'fog/core/collection'
require 'fog/xenserver/models/compute/bond'

module Fog
  module Compute
    class XenServer
      class Bonds < Fog::Collection
        model Fog::Compute::XenServer::Bond

        def all(options={})
          data = service.get_records 'Bond'
          load(data)
        end

        def get( bond_ref )
          if bond_ref && bond = service.get_record( bond_ref, 'Bond' )
            new(bond)
          else
            nil
          end
        end
      end
    end
  end
end
