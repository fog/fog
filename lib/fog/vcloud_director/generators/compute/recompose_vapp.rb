require 'fog/vcloud_director/generators/compute/compose_common'

module Fog
  module Generators
    module Compute
      module VcloudDirector
        # @see http://pubs.vmware.com/vcd-51/index.jsp#types/RecomposeVAppParamsType.html
        class RecomposeVapp

          include ComposeCommon

          def generate_xml
            Nokogiri::XML::Builder.new do |xml|
              xml.RecomposeVAppParams(vapp_attrs) {
                if has_source_items?
                  build_vapp_instantiation_params(xml)
                  build_source_items(xml)
                end
                build_delete_items(xml)
              }
            end.to_xml
          end

          private

          def build_delete_items(xml)
             @configuration[:vms_to_delete].each { |vm| xml.DeleteItem(:href => vm.href) }
          end

        end
      end
    end
  end
end