#
#
# {:metadata=>{"buenas si"=>"no tanto ya", "hola"=>"adios"},
#  :type=>"application/vnd.vmware.vcloud.metadata+xml",
#  :href=>
#   "https://example.com/api/vApp/vm-18545e82-d919-4071-ae7e-d1300d9d8112/metadata",
#  :id=>"vm-18545e82-d919-4071-ae7e-d1300d9d8112"}
# 
# <Metadata xmlns="http://www.vmware.com/vcloud/v1.5" type="application/vnd.vmware.vcloud.metadata+xml"  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
#   <MetadataEntry>
#         <Key>buenas si</Key>
#         <Value>no tanto ya</Value>
#     </MetadataEntry>
#     <MetadataEntry">
#         <Key>hola</Key>
#         <Value>adios</Value>
#     </MetadataEntry>
# </Metadata>

module Fog
  module Generators
    module Compute
      module VcloudDirector

        class Metadata
           
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
          
          def header
              '<Metadata xmlns="http://www.vmware.com/vcloud/v1.5" 
                type="application/vnd.vmware.vcloud.metadata+xml"  
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
                xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
                '
          end
          
          
          def metadata_entry(key,value)
            body = <<EOF
            <MetadataEntry>
               <Key>#{key}</Key>
               <Value>#{value}</Value>
            </MetadataEntry>
EOF
          end
          
          def tail
            '</Metadata>'
          end
          
        end
      end
    end
  end
end