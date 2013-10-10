Shindo.tests('Compute::VcloudDirector | edge gateway requests', ['vclouddirector']) do

  @service = Fog::Compute::VcloudDirector.new

  tests('Get current organization') do
    session = @service.get_current_session.body
    link = session[:Link].detect do |l|
      l[:type] == 'application/vnd.vmware.vcloud.org+xml'
    end
    @org = @service.get_organization(link[:href].split('/').last).body
  end

  tests('Get first vdc') do
    link = @org[:Link].detect do |l|
      l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end
    @vdc_id = link[:href].split('/').last
  end

  tests('#get_edge_gateways').data_matches_schema(VcloudDirector::Compute::Schema::QUERY_RESULT_RECORDS_TYPE) do
    @edge_gateways = @service.get_edge_gateways(@vdc_id).body

    # ensure that EdgeGatewayRecord is a list
    if @edge_gateways[:EdgeGatewayRecord].is_a?(Hash)
      @edge_gateways[:EdgeGatewayRecord] = [@edge_gateways[:EdgeGatewayRecord]]
    end

    @edge_gateways[:EdgeGatewayRecord].each do |result|
      tests("each EdgeGatewayRecord should follow schema").
        data_matches_schema(VcloudDirector::Compute::Schema::QUERY_RESULT_EDGE_GATEWAY_RECORD_TYPE) { result }
    end

    @edge_gateways
  end

  tests('#get_edge_gateway').data_matches_schema(VcloudDirector::Compute::Schema::GATEWAY_TYPE) do
    @service.get_edge_gateway(@edge_gateways[:EdgeGatewayRecord].first[:href].split('/').last).body
  end

  tests('Retrieve non-existent edge gateway').raises(Excon::Errors::Forbidden) do
    @service.get_edge_gateway('00000000-0000-0000-0000-000000000000')
  end

end
