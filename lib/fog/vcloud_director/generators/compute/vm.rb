module Fog
  module Generators
    module Compute
      module VcloudDirector
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/VmType.html
        class Vm
          attr_reader :attrs

          def initialize(attrs={})
            @attrs = attrs
          end

          def generate_xml
            attrs = @attrs
            Nokogiri::XML::Builder.new do
              Vm('xmlns' => 'http://www.vmware.com/vcloud/v1.5', 'name' => attrs[:name]) {
                Description attrs[:Description] if attrs.key?(:Description)
                if  attrs.key?(:StorageProfile)
                  StorageProfile(
                    'type' => 'application/vnd.vmware.vcloud.vdcStorageProfile+xml',
                    'name' => attrs[:StorageProfile][:name],
                    'href' => attrs[:StorageProfile][:href]
                  )
                end
              }
            end.to_xml
          end
        end
      end
    end
  end
end
