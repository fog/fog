Shindo.tests('Compute::VcloudDirector | network requests', ['vclouddirector']) do

  GET_NETWORK_FORMAT = {
    :type => String,
    :name => String,
    :href => String,
    :id => String,
    :description => Fog::Nullable::String,
    :is_inherited => Fog::Boolean,
    :gateway => Fog::Nullable::String,
    :netmask => String,
    :dns1 => Fog::Nullable::String,
    :dns2 => Fog::Nullable::String,
    :dns_suffix => Fog::Nullable::String,
    :ip_ranges => [{
      :start_address => String,
      :end_address => String
    }]
  }

  @service = Fog::Compute::VcloudDirector.new
  @org = VcloudDirector::Compute::Helper.current_org(@service)

  tests('Create network in non-existent vDC').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.post_create_org_vdc_network('00000000-0000-0000-0000-000000000000', 'bob')
  end

  tests('Delete non-existent OrgNetwork').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.delete_network('00000000-0000-0000-0000-000000000000')
  end

  tests('#get_network').data_matches_schema(GET_NETWORK_FORMAT) do
    link = @org[:Link].detect do |l|
      l[:rel] == 'down' && l[:type] == 'application/vnd.vmware.vcloud.orgNetwork+xml'
    end
    pending unless link # nothing to test here cannot continue
    @network_id = link[:href].split('/').last
    @service.get_network(@network_id).body
  end

  tests('#get_network_metadata').data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
    pending if Fog.mocking?
    pending unless @network_id  # nothing to test here cannot continue
    @service.get_network_metadata(@network_id).body
  end

  tests('Retrieve non-existent OrgNetwork').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.get_network('00000000-0000-0000-0000-000000000000')
  end

  # at the moment just test delete_network in Mock mode, until we have
  # ability to create a test one in Real mode
  if Fog.mocking?
    # TODO replace with a Query API lookup when available
    net_id = @service.data[:networks].keys.first
    @delete_task = @service.delete_network(net_id).body
    tests('#delete_network returns Task').data_matches_schema(VcloudDirector::Compute::Schema::TASK_TYPE) do
      @delete_task
    end
    @service.process_task(@delete_task)
    tests('#delete_network succeeds').returns(nil) do
      # network missing now?
      net_id = @service.data[:networks][net_id]
    end
  end

end
