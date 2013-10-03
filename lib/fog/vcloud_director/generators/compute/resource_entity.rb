module Fog
  module Generators
    module Compute
      module VcloudDirector
        require 'fog/vcloud_director/generators/compute/entity'

        # Base type that represents a resource entity such as a vApp template
        #   or virtual media.
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/ResourceEntityType.html
        #   vCloud API Documentation
        class ResourceEntity < Entity
        end
      end
    end
  end
end
