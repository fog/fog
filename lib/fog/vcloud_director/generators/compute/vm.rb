module Fog
  module Generators
    module Compute
      module VcloudDirector
        #     {
        #         :name => "webapp-1",
        #         :Description => "Vm Created from Ubuntu 12.04.3 LTS, VMware Tools latest installed.",
        #         :StorageProfile =>
        #         {
        #           :name => "BASIC-Storage-Profile",
        #           :href => "https://api.vcd.portal.skyscapecloud.com/api/vdcStorageProfile/a1c0d210-92c9-4514-b146-4b625e6c74dd"
        #         },
        #     }
        #
        # This is what it generates:
        #
        #    <Vm xmlns="http://www.vmware.com/vcloud/v1.5"
        #       name="webapp-1" type="application/vnd.vmware.vcloud.vm+xml">
        #    <Description>Vm Created from Ubuntu 12.04.3 LTS, VMware Tools latest installed.</Description>
        #    <StorageProfile
        #       type="application/vnd.vmware.vcloud.vdcStorageProfile+xml"
        #       name="BASIC-Storage-Profile"
        #       href="https://api.vcd.portal.skyscapecloud.com/api/vdcStorageProfile/a1c0d210-92c9-4514-b146-4b625e6c7455"/>
        #    </Vm>
        #
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
