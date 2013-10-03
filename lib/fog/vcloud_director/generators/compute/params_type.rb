module Fog
  module Generators
    module Compute
      module VcloudDirector
        require 'fog/vcloud_director/generators/compute/base'

        # A basic type used to specify request parameters.
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/ParamsType.html
        #   vCloud API Documentation
        class ParamsType < Base

          # @param [Hash] data
          # @option data [String] :name Typically used to name or identify the
          #   subject of the request. For example, the name of the object being
          #   created or modified.
          # @option data [String] :Description Optional description.
          def initialize(data={})
            super
            @root_attributes[:xmlns] = 'http://www.vmware.com/vcloud/v1.5'
            @root_attributes[:name] = data.delete(:name)
          end

          protected

          def inner_build(xml)
            xml.Description data.delete(:Description)
          end

        end
      end
    end
  end
end
