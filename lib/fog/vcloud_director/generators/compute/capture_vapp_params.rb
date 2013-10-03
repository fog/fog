module Fog
  module Generators
    module Compute
      module VcloudDirector
        require 'fog/vcloud_director/generators/compute/params_type'

        attr_reader :source

        # Parameters for a captureVapp request.
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/CaptureVAppParamsType.html
        #   vCloud API Documentation
        class CaptureVAppParams < ParamsType

          # @params [Hash] data
          def initialize(source_href, data={})
            data[:source] = {:href => source_href}
            super data
            @root_attributes[:'xmlns:ovf'] = 'http://schemas.dmtf.org/ovf/envelope/1'
            @source = {:href => source_href}
          end

          protected

          def inner_build(xml)
            super
            xml.Source(:href => data.delete(:source)[:href])
            #xml.VdcStorageProfile(:href => source_href) # since 5.1
          end
        end
      end
    end
  end
end
