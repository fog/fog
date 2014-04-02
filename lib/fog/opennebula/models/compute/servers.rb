require 'fog/core/collection'
require 'fog/opennebula/models/compute/server'


module Fog
  module Compute
    class OpenNebula

      class Servers < Fog::Collection

        model Fog::Compute::OpenNebula::Server

        def all(filter={})
          load(service.list_vms(filter))
        end

        def get(id)
	  Fog::Logger.warning("FIRST id #{id.inspect}")
          data = service.list_vms({:id => id})
	  Fog::Logger.warning("FIRST #{data.inspect}")
          new data.first unless data.empty?
        end

      end
    end
  end
end

