Shindo.tests('Compute::VcloudDirector | edge gateway requests', ['vclouddirector']) do

  FIREWALL_RULE_ID = '9999'

  @dhcp_configuration = {
    :GatewayDhcpService => {
      :IsEnabled => "true",
      :pools => [{
        :IsEnabled => "true",
        :Network => "testNet",
        :DefaultLeaseTime => "65",
        :MaxLeaseTime => "650",
        :LowIpAddress => "192.168.9.2",
        :HighIpAddress => "192.168.9.20"
      }]
    }
  }

  @vpn_configuration = {
    :GatewayIpsecVpnService => 
      {
        :IsEnabled => "true",
        :Tunnel => [{
          :Name => "test vpn",
          :PeerIpAddress => "110.110.110.110",
          :PeerId => "1223-123UDH-12321",
          :LocalIpAddress => "192.168.90.90",
          :LocalId => "202UB-9602-UB629",
          :PeerSubnet => [{
            :Name => "192.168.0.0/18",
            :Gateway => "192.168.0.0",
            :Netmask => "255.255.192.0",
          }],
          :SharedSecret => "dont tell anyone",
          :SharedSecretEncrypted => "false",
          :EncryptionProtocol => "AES",
          :Mtu => "1500",
          :IsEnabled => "true",
          :LocalSubnet => [{
            :Name => "VDC Network",
            :Gateway => "192.168.90.254",
            :Netmask => "255.255.255.0"
          }]
        }]
      }
  }

  @routing_service_configuration = {
    :StaticRoutingService => {
      :IsEnabled => "true",
      :StaticRoute => [
        {
          :Name => "Test static route #1",
          :Network => "192.168.192.0/24",
          :NextHopIp => "192.168.0.1",
          :GatewayInterface => {}
        }
      ]
    }
  }

  @new_edge_gateway_configuration = {
    :FirewallService =>
      {
        :IsEnabled => "true",
        :DefaultAction => "allow",
        :LogDefaultAction => "false",
        :FirewallRule => [
          {
            :IsEnabled => "false",
            :MatchOnTranslate => "false",
            :Id => FIREWALL_RULE_ID,
            :Policy => "drop",
            :Description => "generated from edge_gateway_tests",
            :Protocols => {
              :Tcp => "true"
            },
            :Port => "3412",
            :DestinationPortRange => "3412",
            :DestinationIp => "internal",
            :SourcePort => "3412",
            :SourceIp => "internal",
            :SourcePortRange => "3412",
            :EnableLogging => "false"
          }
        ]
      }
  }.merge!(@vpn_configuration).merge!(@dhcp_configuration)

  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)

  tests('Get first vDC with an EdgeGatewayRecord') do
    @org[:Link].each do |l|
      if l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
        id = l[:href].split('/').last
        edge_gateways = @service.get_org_vdc_gateways(id).body
        if edge_gateways && edge_gateways[:EdgeGatewayRecord].size >= 1
          @vdc_id = id
          break
        end
      end
    end
  end

  tests('#get_org_vdc_gateways').data_matches_schema(VcloudDirector::Compute::Schema::QUERY_RESULT_RECORDS_TYPE) do
    begin
      @edge_gateways = @service.get_org_vdc_gateways(@vdc_id).body
    rescue Fog::Compute::VcloudDirector::Unauthorized # bug, may be localised
      retry
    end
    @edge_gateways
  end

  @edge_gateways[:EdgeGatewayRecord].each do |result|
    tests("each EdgeGatewayRecord").
      data_matches_schema(VcloudDirector::Compute::Schema::QUERY_RESULT_EDGE_GATEWAY_RECORD_TYPE) do
        result
      end
  end

  tests('#get_edge_gateway').data_matches_schema(VcloudDirector::Compute::Schema::GATEWAY_TYPE) do
    @edge_gateway_id = @edge_gateways[:EdgeGatewayRecord].first[:href].split('/').last
    @original_gateway_conf = @service.get_edge_gateway(@edge_gateway_id).body
  end

  tests('#configure_edge_gateway_services') do

    rule = @original_gateway_conf[:Configuration][:EdgeGatewayServiceConfiguration][:FirewallService][:FirewallRule].find { |rule| rule[:Id] == FIREWALL_RULE_ID }
    raise('fail fast if our test firewall rule already exists - its likely left over from a broken test run') if rule

    response = @service.post_configure_edge_gateway_services(@edge_gateway_id, @new_edge_gateway_configuration)
    @service.process_task(response.body)

    tests('#check for DHCP configuration').returns(@new_edge_gateway_configuration[:GatewayDhcpService][:IsEnabled]) do
      edge_gateway = @service.get_edge_gateway(@edge_gateway_id).body
      edge_gateway[:Configuration][:EdgeGatewayServiceConfiguration][:GatewayDhcpService][:IsEnabled]
    end

    tests('#check for VPN').returns(@new_edge_gateway_configuration[:GatewayIpsecVpnService][:IsEnabled]) do
      edge_gateway = @service.get_edge_gateway(@edge_gateway_id).body
      edge_gateway[:Configuration][:EdgeGatewayServiceConfiguration][:GatewayIpsecVpnService][:IsEnabled]
    end

    tests('#check for new firewall rule').returns(@new_edge_gateway_configuration[:FirewallService][:FirewallRule]) do
      edge_gateway = @service.get_edge_gateway(@edge_gateway_id).body
      edge_gateway[:Configuration][:EdgeGatewayServiceConfiguration][:FirewallService][:FirewallRule]
    end

    tests('#remove the firewall rule added by test').returns(nil) do
      response = @service.post_configure_edge_gateway_services(@edge_gateway_id,
                                                               @original_gateway_conf[:Configuration][:EdgeGatewayServiceConfiguration])
      @service.process_task(response.body)
      edge_gateway = @service.get_edge_gateway(@edge_gateway_id).body
      edge_gateway[:Configuration][:EdgeGatewayServiceConfiguration][:FirewallService][:FirewallRule].find { |rule| rule[:Id] == FIREWALL_RULE_ID }
    end

    tests('#check Static Routing service configuration').returns(true) do
      edge_gateway = @service.get_edge_gateway(@edge_gateway_id).body
      gateway_interface = edge_gateway[:Configuration][:GatewayInterfaces][:GatewayInterface].first
      @routing_service_configuration[:StaticRoutingService][:StaticRoute].first[:GatewayInterface] = {
        :type => gateway_interface[:type],
        :name => gateway_interface[:name],
        :href => gateway_interface[:href]
      }

      response = @service.post_configure_edge_gateway_services(@edge_gateway_id,
                                                               @routing_service_configuration)
      @service.process_task(response.body)
      edge_gateway = @service.get_edge_gateway(@edge_gateway_id).body
      edge_gateway[:Configuration][:EdgeGatewayServiceConfiguration][:StaticRoutingService][:IsEnabled] == "true"
    end

    tests('#check VPN xml from generator').returns(true) do
      xml = Nokogiri.XML Fog::Generators::Compute::VcloudDirector::EdgeGatewayServiceConfiguration.new(@vpn_configuration).generate_xml
      #Not comprehensive, only checks that the generator actually knows how to handle it and that the output looks vagely sane
      paths = {
        'GatewayIpsecVpnService>IsEnabled' => 'true',
        'Tunnel>Name' => 'test vpn',
        'Tunnel>PeerIpAddress' => '110.110.110.110',
        'Tunnel>LocalSubnet>Gateway' => '192.168.90.254',
        'Tunnel>PeerSubnet>Netmask' => '255.255.192.0' }
      paths.none? { |path| (xml.css path[0]).inner_text != path[1] }
    end

    tests('#check DHCP xml from generator').returns(true) do
      xml = Nokogiri.XML Fog::Generators::Compute::VcloudDirector::EdgeGatewayServiceConfiguration.new(@dhcp_configuration).generate_xml
      paths = {
          'GatewayDhcpService>IsEnabled' => "true",
          'GatewayDhcpService>Pool>IsEnabled' => "true",
          'GatewayDhcpService>Pool>Network' => "testNet",
          'GatewayDhcpService>Pool>DefaultLeaseTime' => "65",
          'GatewayDhcpService>Pool>MaxLeaseTime' => "650",
          'GatewayDhcpService>Pool>LowIpAddress' => "192.168.9.2",
          'GatewayDhcpService>Pool>HighIpAddress' => "192.168.9.20" }
      paths.none? { |path| (xml.css path[0]).inner_text != path[1] }
    end

end

  tests('Retrieve non-existent edge gateway').raises(Fog::Compute::VcloudDirector::Forbidden) do
    begin
      @service.get_edge_gateway('00000000-0000-0000-0000-000000000000')
    rescue Fog::Compute::VcloudDirector::Unauthorized # bug, may be localised
      retry
    end
  end

  tests('Configure non-existent edge gateway').raises(Fog::Compute::VcloudDirector::Forbidden) do
    begin
      @service.post_configure_edge_gateway_services('00000000-0000-0000-0000-000000000000', {})
    rescue Fog::Compute::VcloudDirector::Unauthorized # bug, may be localised
      retry
    end
  end

end
