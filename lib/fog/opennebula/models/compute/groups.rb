require 'fog/core/collection'
require 'fog/opennebula/models/compute/group'

module Fog
  module Compute
    class OpenNebula

      class Groups < Fog::Collection

        model Fog::Compute::OpenNebula::Group

        def all(filter={})
          load(service.list_groups(filter))
        end

        def get(id)
          # the one api does not provide any filter method and this isn't really important
          # get all and filter on your own :D
          #self.all({:id => id}).first
          raise Fog::Errors::Error.new('get a group is not yet implemented. Contributions welcome!')
        end

      end

    end
  end
end
