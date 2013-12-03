require 'fog/core/collection'
require 'fog/vsphere/models/compute/customfield'

module Fog
  module Compute
    class Vsphere

      class Customfields < Fog::Collection

        model Fog::Compute::Vsphere::Customfield

        attr_accessor :vm

        def all(filters = {})
          load service.list_customfields()
        end

        def get(key)
          load(service.list_customfields()).find do | cv | 
            cv.key == ((key.is_a? String) ? key.to_i : key)
          end
        end

     end
    end
  end
end
