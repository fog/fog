module Fog
  module Generators
    module Compute
      module VcloudDirector
        #   {:metadata=>
        #    {"buenas si"=>"no tanto ya",
        #     "hola"=>"adios"},
        #    :type=>"application/vnd.vmware.vcloud.metadata+xml",
        #    :href=>
        #     "https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata",
        #    :id=>"vm-18545e82-d919-4071-ae7e-d1300d9d8112"}
        #
        # This is what it generates:
        #
        #   <Metadata xmlns="http://www.vmware.com/vcloud/v1.5" type="application/vnd.vmware.vcloud.metadata+xml"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
        #     <MetadataEntry>
        #       <Key>buenas si</Key>
        #       <Value>no tanto ya</Value>
        #     </MetadataEntry>
        #     <MetadataEntry">
        #       <Key>hola</Key>
        #       <Value>adios</Value>
        #     </MetadataEntry>
        #   </Metadata>
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/MetadataType.html
        class MetadataBase
          attr_reader :attrs

          def initialize(attrs={})
            @attrs = attrs
          end

          def generate_xml
            output = ""
            output << header
            attrs[:metadata].each_pair do |k,v|
              output << metadata_entry(k,v)
            end
            output << tail
            output
          end

          def add_item(k,v)
            @attrs[:metadata].merge!(Hash[k,v])
          end

          # 1.5
          def header
            <<-END
            <Metadata
              xmlns="http://www.vmware.com/vcloud/v1.5"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              type="application/vnd.vmware.vcloud.metadata+xml">
            END
          end

          def metadata_entry
            raise "This is an abstract class. Use the appropriate subclass"
          end

          # 5.1
          #def header
          #  '<Metadata xmlns="http://www.vmware.com/vcloud/v1.5"
          #    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          #    type="application/vnd.vmware.vcloud.metadata+xml"
          #    href="https://devlab.mdsol.com/api/vApp/vm-345c3619-edcd-4a8c-a8b9-c69ace3f89d1/metadata"
          #    xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">'
          #end

          def tail
            <<-END
            </Metadata>
            END
          end
        end

        class MetadataV51 < MetadataBase
          def metadata_entry(key, value)
            <<-END
            <MetadataEntry type="application/vnd.vmware.vcloud.metadata.value+xml">
              <Key>#{key}</Key>
              <TypedValue xsi:type="MetadataStringValue">
                <Value>#{value}</Value>
              </TypedValue>
            </MetadataEntry>
            END
          end
        end

        class MetadataV15 < MetadataBase
          def metadata_entry(key, value)
            <<-END
            <MetadataEntry>
              <Key>#{key}</Key>
              <Value>#{value}</Value>
            </MetadataEntry>
            END
          end
        end
      end
    end
  end
end
