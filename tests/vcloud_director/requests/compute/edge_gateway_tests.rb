Shindo.tests('Compute::VcloudDirector | edge gateway requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)

  tests('Get first vDC') do
    link = @org[:Link].detect do |l|
      l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end
    @vdc_id = link[:href].split('/').last
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
      data_matches_schema(VcloudDirector::Compute::Schema::QUERY_RESULT_EDGE_GATEWAY_RECORD_TYPE) { result }
  end

  tests('#get_edge_gateway').data_matches_schema(VcloudDirector::Compute::Schema::GATEWAY_TYPE) do
    @edge_gateway_id = @edge_gateways[:EdgeGatewayRecord].first[:href].split('/').last
    @edge_gateway_configuration = @service.get_edge_gateway(@edge_gateway_id).body
  end

  tests('#post_configure_edge_gateway_services') do
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
                        :Id => "1000",
                        :Policy => "drop",
                        :Description => "description",
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
    }

    response = @service.post_configure_edge_gateway_services(@edge_gateway_id, @new_edge_gateway_configuration)
    @service.process_task(response.body) unless Fog.mocking?
  end

  tests('#check for new firewall rule').returns(@new_edge_gateway_configuration[:FirewallService][:FirewallRule]) do
    edge_gateway = @service.get_edge_gateway(@edge_gateway_id).body

    edge_gateway[:Configuration][:EdgeGatewayServiceConfiguration][:FirewallService][:FirewallRule]
  end

  tests('#remove the firewall rule added by test').returns(nil) do
    response = @service.post_configure_edge_gateway_services(@edge_gateway_id,
                                                         @edge_gateway_configuration[:Configuration][:EdgeGatewayServiceConfiguration])

    @service.process_task(response.body) unless Fog.mocking?

    edge_gateway = @service.get_edge_gateway(@edge_gateway_id).body
    edge_gateway[:Configuration][:EdgeGatewayServiceConfiguration][:FirewallService][:FirewallRule].find { |rule| rule[:Id] == '1000' }
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
