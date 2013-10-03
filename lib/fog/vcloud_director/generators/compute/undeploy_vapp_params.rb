module Fog
  module Generators
    module Compute
      module VcloudDirector
        require 'fog/vcloud_director/generators/compute/params_type'

        # Parameters to an undeploy vApp request.
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/UndeployVAppParamsType.html
        #   vCloud API Documentation
        class UndeployVAppParams < ParamsType

          protected

          def inner_build(xml)
            if data.has_key?(:UndeployPowerAction)
              xml.UndeployPowerAction data.delete(:UndeployPowerAction)
            end
          end

        end
      end
    end
  end
end
