module Fog
  module Generators
    module Compute
      module VcloudDirector
        # This is the data structure it accepts, this is the output of
        # #get_vm_network
        #
        #   {:type=>"application/vnd.vmware.vcloud.networkConnectionSection+xml",
        #    :href=>
        #     "https://example.com/api/vApp/vm-8b74d95a-ee91-4f46-88d8-fc92be0dbaae/networkConnectionSection/",
        #    :id=>"vm-8b74d95a-ee91-4f46-88d8-fc92be0dbaae",
        #    :primary_network_connection_index=>0,
        #    :network=>"DevOps - Dev Network Connection",
        #    :needs_customization=>true,
        #    :network_connection_index=>0,
        #    :ip_address=>"10.192.0.130",
        #    :is_connected=>true,
        #    :mac_address=>"00:50:56:01:00:8d",
        #    :ip_address_allocation_mode=>"POOL"}
        #
        # This is what it generates:
        #
        #   <NetworkConnectionSection xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1" type="application/vnd.vmware.vcloud.networkConnectionSection+xml" href="https://example.com/api/vApp/vm-8b74d95a-ee91-4f46-88d8-fc92be0dbaae/networkConnectionSection/" ovf:required="false" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.dmtf.org/ovf/envelope/1 http://schemas.dmtf.org/ovf/envelope/1/dsp8023_1.1.0.xsd http://www.vmware.com/vcloud/v1.5 http://10.194.1.65/api/v1.5/schema/master.xsd">
        #     <ovf:Info>Specifies the available VM network connections</ovf:Info>
        #     <PrimaryNetworkConnectionIndex>0</PrimaryNetworkConnectionIndex>
        #     <NetworkConnection network="DevOps - Dev Network Connection" needsCustomization="true">
        #       <NetworkConnectionIndex>0</NetworkConnectionIndex>
        #       <IpAddress>10.192.0.130</IpAddress>
        #       <IsConnected>true</IsConnected>
        #       <MACAddress>00:50:56:01:00:8d</MACAddress>
        #       <IpAddressAllocationMode>POOL</IpAddressAllocationMode>
        #     </NetworkConnection>
        #     <Link rel="edit" type="application/vnd.vmware.vcloud.networkConnectionSection+xml" href="https://example.com/api/vApp/vm-8b74d95a-ee91-4f46-88d8-fc92be0dbaae/networkConnectionSection/"/>
        #   </NetworkConnectionSection>
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/types/NetworkConnectionSectionType.html
        class VmNetwork
          attr_reader :attrs

          def initialize(attrs={})
            @attrs = attrs
          end

          def generate_xml
            output = ""
            output << header
            output << body(@attrs)
            output << tail
            output
          end

          def connections
            @attrs[:connections]
          end

          def connections=(new_connections)
            @attrs[:connections] = new_connections
          end

          private

          def header
            <<-END
            <NetworkConnectionSection xmlns="http://www.vmware.com/vcloud/v1.5"
              xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1"
              type="application/vnd.vmware.vcloud.networkConnectionSection+xml">
            END
          end

          def body(opts={})
            connections = <<-END
              <ovf:Info>#{opts[:info]}</ovf:Info>
              <PrimaryNetworkConnectionIndex>#{opts[:primary_network_connection_index]}</PrimaryNetworkConnectionIndex>
            END

            opts[:connections].each do |connection|
              connections << <<-END
                <NetworkConnection
                  network="#{connection[:network]}"
                  needsCustomization="#{connection[:needs_customization]}">
                  <NetworkConnectionIndex>#{connection[:network_connection_index]}</NetworkConnectionIndex>
                  <IpAddress>#{connection[:ip_address]}</IpAddress>
                  <IsConnected>#{connection[:is_connected]}</IsConnected>
                  <MACAddress>#{connection[:mac_address]}</MACAddress>
                  <IpAddressAllocationMode>#{connection[:ip_address_allocation_mode]}</IpAddressAllocationMode>
                </NetworkConnection>
              END
            end
            connections
          end

          def tail
            <<-END
            </NetworkConnectionSection>
            END
          end
        end
      end
    end
  end
end
