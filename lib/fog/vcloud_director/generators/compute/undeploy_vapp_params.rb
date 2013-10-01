module Fog
  module Generators
    module Compute
      module VcloudDirector
        require 'fog/vcloud_director/generators/compute/base'

        # Parameters to an undeploy vApp request.
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/UndeployVAppParamsType.html
        #   vCloud API Documentation
        class UndeployVappParams < Base

          # @api private
          # @return [Nokogiri::XML::Builder]
          def builder
            @builder ||= Nokogiri::XML::Builder.new do |xml|
              xml.UndeployVAppParams(:xmlns => 'http://www.vmware.com/vcloud/v1.5') {
                if options.has_key?(:UndeployPowerAction)
                  xml.UndeployPowerAction options[:UndeployPowerAction]
                end
              }
            end
          end

        end
      end
    end
  end
end
