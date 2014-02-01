# coding: utf-8
Shindo.tests('Fog::Compute[:sakuracloud] | list_servers request', ['sakuracloud', 'compute']) do

  @servers_format = {
    'Index'        => Integer,
    'ID'           => Integer,
    'Name'         => String,
    'ServerPlan'   => Hash,
    'Instance'     => Hash,
    'Disks'        => Array
  }

  tests('success') do

    tests('#list_servers') do
      servers = compute_service.list_servers
      test 'returns a Hash' do
        servers.body.is_a? Hash
      end
      if Fog.mock?
        tests('Servers').formats(@servers_format, false) do
          servers.body['Servers'].first
        end
      else
        returns(200) { servers.status }
        returns(true) { servers.body.is_a? Hash }
      end
    end
  end
end

Shindo.tests('Fog::Compute[:sakuracloud] | create_servers request', ['sakuracloud', 'compute']) do
  tests('success') do
    tests('#create_servers') do
      servers = compute_service.create_server('foobar', 2001)
      test 'returns a Hash' do
        servers.body.is_a? Hash
      end

      unless Fog.mock?
        returns(201) { servers.status }
        returns(true) { servers.body.is_a? Hash }
      end
    end
  end
end
