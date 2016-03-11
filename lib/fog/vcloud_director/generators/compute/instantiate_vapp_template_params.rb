require 'fog/vcloud_director/generators/compute/compose_common'

module Fog
  module Generators
    module Compute
      module VcloudDirector
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/VAppType.html
        class InstantiateVappTemplateParams
          attr_reader :options
          
          include ComposeCommon
        
          def generate_xml
            Nokogiri::XML::Builder.new do |xml|

              
              xml.InstantiateVAppTemplateParams((vapp_attrs)) {
                build_vapp_instantiation_params(xml)
                build_source_template(xml)
                build_source_items(xml)
              }
            end.to_xml

          end
          
        end
      end
    end
  end
end
