require 'fog/vcloud_director/generators/compute/compose_common'

module Fog
  module Generators
    module Compute
      module VcloudDirector
        # @see http://pubs.vmware.com/vcd-51/index.jsp#types/ComposeVAppParamsType.html
        class ComposeVapp

          include ComposeCommon

          def generate_xml
            Nokogiri::XML::Builder.new do |xml|
              xml.ComposeVAppParams(vapp_attrs) {
                build_vapp_instantiation_params(xml)
                build_source_items(xml)
              }
            end.to_xml
          end

        end
      end
    end
  end
end