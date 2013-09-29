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
    :dns1 => String,
    :dns2 => String,
    :dns_suffix => String,
    :ip_ranges => [{
      :start_address => String,
      :end_address => String
    }]
  }

  @service = Fog::Compute::VcloudDirector.new

  tests('Get current organization') do
    session = @service.get_current_session.body
    link = session[:Link].detect do |l|
      l[:type] == 'application/vnd.vmware.vcloud.org+xml'
    end
    @org = @service.get_organization(link[:href].split('/').last).body
  end

  tests('#get_network').data_matches_schema(GET_NETWORK_FORMAT) do
    link = @org[:Link].detect do |l|
      l[:rel] == 'down' && l[:type] == 'application/vnd.vmware.vcloud.orgNetwork+xml'
    end
    @service.get_network(link[:href].split('/').last).body
  end

  tests('Retrieve non-existent OrgNetwork').raises(Excon::Errors::Forbidden) do
    @service.get_network('00000000-0000-0000-0000-000000000000')
  end

end
