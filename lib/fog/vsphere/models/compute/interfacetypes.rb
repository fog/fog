require 'fog/core/collection'
require 'fog/vsphere/models/compute/interfacetype'

module Fog
  module Compute
    class Vsphere
      class Interfacetypes < Fog::Collection
        model Fog::Compute::Vsphere::Interfacetype
        attr_accessor :datacenter
        attr_accessor :servertype

        def all(filters = { })
          requires :servertype
          case servertype
            when Fog::Compute::Vsphere::Servertype
               load service.list_interface_types(filters.merge({
                                                      :datacenter => datacenter,
                                                      :servertype => servertype.id
                                                 }))
            else
               raise 'interfacetypes should have a servertype'
          end
        end

        def get(id)
          requires :servertype
          requires :datacenter
          new service.get_interface_type id, servertype, datacenter
        rescue Fog::Compute::Vsphere::NotFound
          nil
        end
      end
    end
  end
end
