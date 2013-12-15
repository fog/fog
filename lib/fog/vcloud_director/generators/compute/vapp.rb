module Fog
  module Generators
    module Compute
      module VcloudDirector

        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/VmType.html
        class Vapp
          attr_reader :name, :description

          def initialize(name, description=nil)
            @name = name
            @description = description
          end

          def generate_xml
            attrs = @attrs
            Nokogiri::XML::Builder.new do
              VApp('xmlns' => 'http://www.vmware.com/vcloud/v1.5',
                   'name' => name
                  ) {
                Description description unless description.nil?
              }
            end.to_xml
          end

        end
      end
    end
  end
end
