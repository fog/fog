module Fog
  module Parsers
    module Compute
      module VcloudDirector
        #
        # <Metadata xmlns="http://www.vmware.com/vcloud/v1.5" type="application/vnd.vmware.vcloud.metadata+xml" href="https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
        #     <Link rel="up" type="application/vnd.vmware.vcloud.vm+xml" href="https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112"/>
        #     <Link rel="add" type="application/vnd.vmware.vcloud.metadata+xml" href="https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata"/>
        #     <MetadataEntry type="application/vnd.vmware.vcloud.metadata.value+xml" href="https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata/buenas%20si">
        #         <Link rel="up" type="application/vnd.vmware.vcloud.metadata+xml" href="https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata"/>
        #         <Link rel="edit" type="application/vnd.vmware.vcloud.metadata.value+xml" href="https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata/buenas%20si"/>
        #         <Link rel="remove" href="https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata/buenas%20si"/>
        #         <Key>buenas si</Key>
        #         <Value>no tanto ya</Value>
        #     </MetadataEntry>
        #     <MetadataEntry type="application/vnd.vmware.vcloud.metadata.value+xml" href="https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata/hola">
        #         <Link rel="up" type="application/vnd.vmware.vcloud.metadata+xml" href="https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata"/>
        #         <Link rel="edit" type="application/vnd.vmware.vcloud.metadata.value+xml" href="https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata/hola"/>
        #         <Link rel="remove" href="https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata/hola"/>
        #         <Key>hola</Key>
        #         <Value>adios</Value>
        #     </MetadataEntry>
        # </Metadata>
        #
        # {:metadata=>{"buenas si"=>"no tanto ya", "hola"=>"adios"},
        #  :type=>"application/vnd.vmware.vcloud.metadata+xml",
        #  :href=>
        #   "https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata",
        #  :id=>"vm-18545e82-d919-4071-ae7e-d1300d9d8112"}
        #
        class Metadata < VcloudDirectorParser
          def reset
            @response = { :metadata => {} }
          end

          def start_element(name, attributes)
            super
            case name
            when 'Metadata'
              metadata = extract_attributes(attributes)
              @response[:type] = metadata[:type]
              @response[:href] = metadata[:href]
              @response[:id] = @response[:href].split('/')[-2]
            end
          end

          def end_element(name)
            case name
            when 'Key'
              @key = value
            when 'Value'
              @val = value
            when 'MetadataEntry'
              @response[:metadata].merge!(Hash[@key, @val])
            end
          end
        end
      end
    end
  end
end
