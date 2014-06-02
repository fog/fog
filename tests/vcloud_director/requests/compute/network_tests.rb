
require 'pp'

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
  @created_net_id = nil

  tests('Create network in non-existent vDC').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.post_create_org_vdc_network('00000000-0000-0000-0000-000000000000', 'bob')
  end

  tests('Delete non-existent OrgNetwork').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.delete_network('00000000-0000-0000-0000-000000000000')
  end

  tests('Retrieve non-existent OrgNetwork (get_network)').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.get_network('00000000-0000-0000-0000-000000000000')
  end

  tests('Retrieve non-existent OrgNetwork (get_network_complete)').raises(Fog::Compute::VcloudDirector::Forbidden) do
    @service.get_network_complete('00000000-0000-0000-0000-000000000000')
  end

  tests('#get_network').data_matches_schema(GET_NETWORK_FORMAT) do
    link = @org[:Link].find do |l|
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

  tests('#post_create_org_vdc_network') do
    #pending unless Fog.mocking?
    link = @org[:Link].find do |l|
      l[:rel] == 'down' && l[:type] == 'application/vnd.vmware.vcloud.vdc+xml'
    end

    vdc_id = link[:href].split('/').last
    name = VcloudDirector::Compute::Helper.test_name

    options = {
      :Description => "Testing post_create_org_vdc_network #{name}",
      :Configuration => {
        :IpScopes => {
          :IpScope => {
            :IsInherited => 'false',
            :Gateway => '198.51.100.1',
            :Netmask => '255.255.255.0',
            :Dns1    => '198.51.100.2',
            :Dns2    => '198.51.100.3',
            :DnsSuffix => 'example.com',
            :IpRanges => [
              { :IpRange => { :StartAddress => '198.51.100.10', :EndAddress => '198.51.100.20' } },
              { :IpRange => { :StartAddress => '198.51.100.30', :EndAddress => '198.51.100.40' } },
            ]
          },
        },
        :FenceMode => 'isolated',
      }
    }

    body = @service.post_create_org_vdc_network(vdc_id, name, options).body
    @created_net_id = body[:href].split('/').last if body[:href]
    @service.process_task(body[:Tasks][:Task]) if body && body.key?(:Tasks)

    tests('fetched name matches created name').returns(name) do
      net = @service.get_network_complete(@created_net_id).body
      net[:name]
    end

  end

  tests('#get_network_complete schema').data_matches_schema(VcloudDirector::Compute::Schema::NETWORK_TYPE) do
    link = @org[:Link].find do |l|
      l[:rel] == 'down' && l[:type] == 'application/vnd.vmware.vcloud.orgNetwork+xml'
    end
    pending unless link # nothing to test here cannot continue
    @network_id = link[:href].split('/').last
    @service.get_network_complete(@network_id).body
  end

  tests('#get_network_complete') do
    new_network = @service.get_network_complete(@created_net_id).body
    tests('network has a :name') do
      new_network.fetch(:name)
    end
    tests('network has a :Description') do
      new_network.fetch(:Description)
    end
    tests('network has a :Gateway') do
      new_network[:Configuration][:IpScopes][:IpScope][:Gateway]
    end
    tests('network has a several :IpRanges') do
      new_network[:Configuration][:IpScopes][:IpScope][:IpRanges].size >= 1
    end
  end

  tests('#put_network') do

    new_options = {
      :Description => "Testing put_network",
      :Configuration => {
        :IpScopes => {
          :IpScope => {
            :IsInherited => 'false',
            :Gateway => '198.51.100.1',
            :Netmask => '255.255.255.0',
            :Dns1    => '198.51.100.2',
            :Dns2    => '198.51.100.3',
            :DnsSuffix => 'example.com',
            :IpRanges => [
              { :IpRange => { :StartAddress => '198.51.100.10', :EndAddress => '198.51.100.20' } },
              { :IpRange => { :StartAddress => '198.51.100.30', :EndAddress => '198.51.100.40' } },
            ]
          },
        },
        :FenceMode => 'isolated',
      }
    }

    original_network = @service.get_network_complete(@created_net_id).body
    name = original_network[:name]

    task = @service.put_network(@created_net_id, name, new_options).body
    @service.process_task(task)

    tests('fetched :Gateway matches updated :Gateway').returns(
      new_options[:Configuration][:IpScopes][:IpScope][:Gateway]
    ) do
      net = @service.get_network_complete(@created_net_id).body
      net[:Configuration][:IpScopes][:IpScope][:Gateway]
    end

    tests('fetched :IpRanges count is matches updated data').returns(
      new_options[:Configuration][:IpScopes][:IpScope][:IpRanges].size
    ) do
      net = @service.get_network_complete(@created_net_id).body
      # dammit, the API returns with IpRange as a list, not IpRanges
      net[:Configuration][:IpScopes][:IpScope][:IpRanges][:IpRange].size
    end

    tests('fetched :Network matches updated :Description').returns(
      new_options[:Description]
    ) do
      net = @service.get_network_complete(@created_net_id).body
      net[:Description]
    end

  end

  tests('#delete_network') do
    @delete_task = @service.delete_network(@created_net_id).body
    @service.process_task(@delete_task)
    tests('created network has been deleted').raises(Fog::Compute::VcloudDirector::Forbidden) do
      @service.get_network(@created_net_id)
    end
  end

end
