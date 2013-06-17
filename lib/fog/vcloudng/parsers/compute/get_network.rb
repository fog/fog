#
# <?xml version="1.0" encoding="UTF-8"?>
# <OrgNetwork xmlns="http://www.vmware.com/vcloud/v1.5" name="DevOps - Dev Network Connection" id="urn:vcloud:network:d5f47bbf-de27-4cf5-aaaa-56772f2ccd17" type="application/vnd.vmware.vcloud.orgNetwork+xml" href="https://devlab.mdsol.com/api/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
#     <Link rel="up" type="application/vnd.vmware.vcloud.org+xml" name="DevOps" href="https://devlab.mdsol.com/api/org/c6a4c623-c158-41cf-a87a-dbc1637ad55a"/>
#     <Link rel="down" type="application/vnd.vmware.vcloud.metadata+xml" href="https://devlab.mdsol.com/api/network/d5f47bbf-de27-4cf5-aaaa-56772f2ccd17/metadata"/>
#     <Description/>
#     <Configuration>
#         <IpScope>
#             <IsInherited>true</IsInherited>
#             <Gateway>10.192.0.1</Gateway>
#             <Netmask>255.255.252.0</Netmask>
#             <Dns1>10.192.0.11</Dns1>
#             <Dns2>10.192.0.12</Dns2>
#             <DnsSuffix>dev.ad.mdsol.com</DnsSuffix>
#             <IpRanges>
#                 <IpRange>
#                     <StartAddress>10.192.0.100</StartAddress>
#                     <EndAddress>10.192.3.254</EndAddress>
#                 </IpRange>
#             </IpRanges>
#         </IpScope>
#         <FenceMode>bridged</FenceMode>
#         <RetainNetInfoAcrossDeployments>false</RetainNetInfoAcrossDeployments>
#     </Configuration>
# </OrgNetwork>

module Fog
  module Parsers
    module Vcloudng
      module Compute


        class GetNetwork < VcloudngParser

          def reset
            @response = {
              "Links" => [], "IpRanges" => []
            }
            @ip_range = {}
          end

          def start_element(name,attributes=[])
            super
            case name
            when "Link"
              link = extract_attributes(attributes)
              @response["Links"] << link
            end
          end

          def end_element(name)
            case name
            when "Gateway", "Netmask", "Dns1", "Dns2", "DnsSuffix",  "FenceMode"
              @response[name] = value
            when "IsInherited", "RetainNetInfoAcrossDeployments"
              @response[name] = value.to_bool
            when "StartAddress", "EndAddress"
              @ip_range[name] = value
              if @ip_range.keys.size == 2
                @response["IpRanges"] << @ip_range
                @ip_range = {}
              end
            end
          end

        end

      end
    end
  end
end
