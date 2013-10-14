Shindo.tests('Compute::VcloudDirector | network requests', ['vclouddirector']) do

  GET_NETWORK_FORMAT = {
    :type => String,
    :name => String,
    :href => String,
    :id => String,
    :description => Fog::Nullable::String,
    :is_inherited => Fog::Boolean,
    :gateway => String,
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

  tests('#get_network').data_matches_schema(GET_NETWORK_FORMAT) do
    link = @org[:Link].detect do |l|
      l[:rel] == 'down' && l[:type] == 'application/vnd.vmware.vcloud.orgNetwork+xml'
    end
    @network_id = link[:href].split('/').last
    @service.get_network(@network_id).body
  end

  tests('#get_network_metadata').data_matches_schema(VcloudDirector::Compute::Schema::METADATA_TYPE) do
    pending if Fog.mocking?
    @service.get_network_metadata(@network_id).body
  end

  tests('Retrieve non-existent OrgNetwork').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.get_network('00000000-0000-0000-0000-000000000000')
  end

end
