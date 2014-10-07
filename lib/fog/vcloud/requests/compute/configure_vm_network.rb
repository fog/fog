# -*- encoding: utf-8 -*-
module Fog
  module Vcloud
    class Compute
      class Real
        def configure_vm_network(network_info)
          edit_uri = network_info.select {|k,v| k == :Link && v[:rel] == 'edit'}
          edit_uri = edit_uri.kind_of?(Array) ? edit_uri.flatten[1][:href] : edit_uri[:Link][:href]

          body = <<EOF
            <NetworkConnectionSection xmlns="http://www.vmware.com/vcloud/v1.5" xmlns:ovf="http://schemas.dmtf.org/ovf/envelope/1" type="application/vnd.vmware.vcloud.networkConnectionSection+xml" href="#{edit_uri}">
              <ovf:Info>Specifies the available VM network connections</ovf:Info>
              <PrimaryNetworkConnectionIndex>0</PrimaryNetworkConnectionIndex>
              <NetworkConnection network="#{network_info[:NetworkConnection][:network]}" needsCustomization="true">
                <NetworkConnectionIndex>0</NetworkConnectionIndex>
                <IsConnected>true</IsConnected>
                <IpAddressAllocationMode>#{network_info[:NetworkConnection][:IpAddressAllocationMode]}</IpAddressAllocationMode>
              </NetworkConnection>
            </NetworkConnectionSection>
EOF
          request(
            :body     => body,
            :expects  => 202,
            :headers  => {'Content-Type' => network_info[:"type"] },
            :method   => 'PUT',
            :uri      => "#{edit_uri}",
            :parse    => true
          )
        end
      end
    end
  end
end
