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
    @service.get_edge_gateway(@edge_gateways[:EdgeGatewayRecord].first[:href].split('/').last).body
  end

  tests('Retrieve non-existent edge gateway').raises(Fog::Compute::VcloudDirector::Forbidden) do
    begin
      @service.get_edge_gateway('00000000-0000-0000-0000-000000000000')
    rescue Fog::Compute::VcloudDirector::Unauthorized # bug, may be localised
      retry
    end
  end

end
