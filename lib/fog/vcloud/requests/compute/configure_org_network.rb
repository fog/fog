# -*- coding: utf-8 -*-
module Fog
  module Vcloud
    class Compute
      class Real
        def generate_outbound_rule()
          outbound_rule = <<EOF
            <ns0:FirewallRule>
            <ns0:IsEnabled>true</ns0:IsEnabled>
            <ns0:Description>OUTGOING</ns0:Description>
            <ns0:Policy>allow</ns0:Policy>
            <ns0:Protocols>
                <ns0:Any>true</ns0:Any>
            </ns0:Protocols>
            <ns0:Port>-1</ns0:Port>
            <ns0:DestinationIp>Any</ns0:DestinationIp>
            <ns0:SourcePort>-1</ns0:SourcePort>
            <ns0:SourceIp>Any</ns0:SourceIp>
            <ns0:Direction>out</ns0:Direction>
            <ns0:EnableLogging>false</ns0:EnableLogging>
        </ns0:FirewallRule>
EOF
        outbound_rule
        end

        def generate_tcp_rules(tcp_ports)
          firewall_rules = ""
          tcp_ports.each do |port|
            firewall_rules << <<EOF
                    <ns0:FirewallRule>
                    <ns0:IsEnabled>true</ns0:IsEnabled>
                    <ns0:Description>#{port}</ns0:Description>
                    <ns0:Policy>allow</ns0:Policy>
                    <ns0:Protocols>
                    <ns0:Tcp>true</ns0:Tcp>
                    </ns0:Protocols>
                    <ns0:Port>#{port}</ns0:Port>
                    <ns0:DestinationIp>Any</ns0:DestinationIp>
                    <ns0:SourcePort>-1</ns0:SourcePort>
                    <ns0:SourceIp>Any</ns0:SourceIp>
                    <ns0:Direction>in</ns0:Direction>
                    <ns0:EnableLogging>false</ns0:EnableLogging>
                    </ns0:FirewallRule>
EOF
          end
          firewall_rules
        end

        def generate_udp_rules(udp_ports)
          firewall_rules = ""
          udp_ports.each do |port|
              firewall_rules << <<EOF
                    <ns0:FirewallRule>
                    <ns0:IsEnabled>true</ns0:IsEnabled>
                    <ns0:Description>#{port}</ns0:Description>
                    <ns0:Policy>allow</ns0:Policy>
                    <ns0:Protocols>
                    <ns0:Udp>true</ns0:Udp>
                    </ns0:Protocols>
                    <ns0:Port>#{port}</ns0:Port>
                    <ns0:DestinationIp>Any</ns0:DestinationIp>
                    <ns0:SourcePort>-1</ns0:SourcePort>
                    <ns0:SourceIp>Any</ns0:SourceIp>
                    <ns0:Direction>in</ns0:Direction>
                    <ns0:EnableLogging>false</ns0:EnableLogging>
                    </ns0:FirewallRule>
EOF
          end
          firewall_rules
        end

        def generate_configure_org_network_request(vapp_id, vapp_network, vapp_network_uri, org_network, org_network_uri, enable_firewall=false, portmap=nil)
          firewall_body = ""
          if not enable_firewall
            firewall_body = "<ns0:IsEnabled>false</ns0:IsEnabled>"

          else
            firewall_rules = generate_outbound_rule + generate_tcp_rules(portmap["TCP"]) + generate_udp_rules(portmap["UDP"])
                    firewall_body = <<EOF
                            <ns0:IsEnabled>true</ns0:IsEnabled>
                            <ns0:DefaultAction>drop</ns0:DefaultAction>
                            <ns0:LogDefaultAction>false</ns0:LogDefaultAction>
                            #{firewall_rules}
EOF
          end
        body = <<EOF
          <ns0:NetworkConfigSection xmlns:ns0="http://www.vmware.com/vcloud/v1.5" xmlns:ns1="http://schemas.dmtf.org/ovf/envelope/1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" href="#{vapp_id}/networkConfigSection/" type="application/vnd.vmware.vcloud.networkConfigSection+xml" ns1:required="false" xsi:schemaLocation="http://schemas.dmtf.org/ovf/envelope/1 http://schemas.dmtf.org/ovf/envelope/1/dsp8023_1.1.0.xsd http://www.vmware.com/vcloud/v1.5 http://zone01.bluelock.com/api/v1.5/schema/master.xsd">
<ns1:Info>The configuration parameters for logical networks</ns1:Info>
<ns0:Link href="#{vapp_id}/networkConfigSection/" rel="edit" type="application/vnd.vmware.vcloud.networkConfigSection+xml" />
<ns0:NetworkConfig networkName="#{vapp_network}">
<ns0:Link href="#{vapp_network_uri}" rel="repair" />
<ns0:Description />
  <ns0:Configuration>
<ns0:ParentNetwork href="#{org_network_uri}" name="#{org_network}" type="application/vnd.vmware.vcloud.network+xml" />
<ns0:FenceMode>natRouted</ns0:FenceMode>
<ns0:RetainNetInfoAcrossDeployments>true</ns0:RetainNetInfoAcrossDeployments>
<ns0:Features>
<ns0:FirewallService>
#{firewall_body}
</ns0:FirewallService>
<ns0:NatService>
<ns0:IsEnabled>true</ns0:IsEnabled>
<ns0:NatType>ipTranslation</ns0:NatType>
<ns0:Policy>allowTraffic</ns0:Policy>
</ns0:NatService>
</ns0:Features>
</ns0:Configuration>
<ns0:IsDeployed>false</ns0:IsDeployed>
</ns0:NetworkConfig>
<ns0:NetworkConfig networkName="#{org_network}"><ns0:Link href="#{org_network_uri}" rel="repair" />
<ns0:Description />
<ns0:Configuration>
<ns0:ParentNetwork href="#{org_network_uri}" name="#{org_network}" type="application/vnd.vmware.vcloud.network+xml" />
<ns0:FenceMode>bridged</ns0:FenceMode>
<ns0:RetainNetInfoAcrossDeployments>true</ns0:RetainNetInfoAcrossDeployments>
<ns0:SyslogServerSettings />
</ns0:Configuration>
</ns0:NetworkConfig>
</ns0:NetworkConfigSection>
EOF
        end

    def configure_org_network(vapp_id, vapp_network, vapp_network_uri, org_network, org_network_uri, enable_firewall=false, port_map=nil)
      body = generate_configure_org_network_request(vapp_id, vapp_network, vapp_network_uri, org_network, org_network_uri, enable_firewall, port_map)
      #puts ("Body: #{body}")

      request(
            :body     => body,
            :expects  => 202,
            :headers  => {'Content-Type' => 'Application/vnd.vmware.vcloud.networkConfigSection+xml' },
            :method   => 'PUT',
            :uri      => "#{vapp_id}/networkConfigSection",
            :parse    => true
          )
    end
      end
    end
  end
end
