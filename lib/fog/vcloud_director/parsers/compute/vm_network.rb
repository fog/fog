module Fog
  module Parsers
    module Compute
      module VcloudDirector
        #
        #<?xml version="1.0" encoding="UTF-8"?>
        #<NetworkConnectionSection xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1" type="application/vnd.vmware.vcloud.networkConnectionSection+xml" href="https://example.com/api/vApp/vm-7b2c35c2-18a6-44b6-ba59-35f2c7e1644e/networkConnectionSection/" ovf:required="false" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://schemas.dmtf.org/ovf/envelope/1 http://schemas.dmtf.org/ovf/envelope/1/dsp8023_1.1.0.xsd http://www.vmware.com/vcloud/v1.5 http://csicloud.csi.it/api/v1.5/schema/master.xsd">
        #    <ovf:Info>Specifies the available VM network connections</ovf:Info>
        #    <PrimaryNetworkConnectionIndex>0</PrimaryNetworkConnectionIndex>
        #    <NetworkConnection network="NET1" needsCustomization="false">
        #        <NetworkConnectionIndex>1</NetworkConnectionIndex>
        #        <IpAddress>10.192.0.102</IpAddress>
        #        <IsConnected>true</IsConnected>
        #        <MACAddress>00:50:56:02:02:40</MACAddress>
        #        <IpAddressAllocationMode>POOL</IpAddressAllocationMode>
        #    </NetworkConnection>
        #    <NetworkConnection network="NET0" needsCustomization="false">
        #        <NetworkConnectionIndex>0</NetworkConnectionIndex>
        #        <IpAddress>10.192.0.101</IpAddress>
        #        <IsConnected>true</IsConnected>
        #        <MACAddress>00:50:56:02:02:3f</MACAddress>
        #        <IpAddressAllocationMode>POOL</IpAddressAllocationMode>
        #    </NetworkConnection>
        #    <Link rel="edit" type="application/vnd.vmware.vcloud.networkConnectionSection+xml" href="https://example.com/api/vApp/vm-7b2c35c2-18a6-44b6-ba59-35f2c7e1644e/networkConnectionSection/"/>
        #</NetworkConnectionSection>
        #
        #{:type=>"application/vnd.vmware.vcloud.networkConnectionSection+xml",
        # :href=>
        #  "https://example.com/api/vApp/vm-7b2c35c2-18a6-44b6-ba59-35f2c7e1644e/networkConnectionSection/",
        # :id=>"vm-7b2c35c2-18a6-44b6-ba59-35f2c7e1644e",
        # :info=>"Specifies the available VM network connections",
        # :primary_network_connection_index=>0,
        # :connections=>
        #  [{:network=>"NET1",
        #    :needsCustomization=>false,
        #    :network_connection_index=>1,
        #    :ip_address=>"10.192.0.102",
        #    :is_connected=>true,
        #    :mac_address=>"00:50:56:02:02:40",
        #    :ip_address_allocation_mode=>"POOL"},
        #   {:network=>"NET0",
        #    :needsCustomization=>false,
        #    :network_connection_index=>0,
        #    :ip_address=>"10.192.0.101",
        #    :is_connected=>true,
        #    :mac_address=>"00:50:56:02:02:3f",
        #    :ip_address_allocation_mode=>"POOL"}]
        # }
        #
        class VmNetwork < VcloudDirectorParser

          def reset
            @response = { :connections => [] }
            @network_connection = {}
          end

          def start_element(name, attributes)
            super
            case name
            when 'NetworkConnectionSection'
              network_connection_section = extract_attributes(attributes)
              @response[:type] = network_connection_section[:type]
              @response[:href] = network_connection_section[:href]
              @response[:id] = @response[:href].split('/')[-2]
            when 'NetworkConnection'
              @network_connection = extract_attributes(attributes)
              @network_connection[:needsCustomization] = ( @network_connection[:needsCustomization] == "true" )
            end
          end

          def end_element(name)
            case name
            when 'Info'
              @response[:info] = value
            when 'PrimaryNetworkConnectionIndex'
              @response[:primary_network_connection_index] = value.to_i
            when 'NetworkConnectionIndex'
              @network_connection[:network_connection_index] = value.to_i
            when 'IpAddress'
              @network_connection[:ip_address] = value
            when 'IsConnected'
              @network_connection[:is_connected] = (value == "true")
            when 'MACAddress'
              @network_connection[:mac_address] = value
            when 'IpAddressAllocationMode'
              @network_connection[:ip_address_allocation_mode] = value
            when 'NetworkConnection'
              @response[:connections] << @network_connection
              @network_connection = {}
            end
          end
        end
      end
    end
  end
end
