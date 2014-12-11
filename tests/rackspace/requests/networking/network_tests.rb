Shindo.tests('Fog::Rackspace::Networking | network_tests', ['rackspace']) do
  service = Fog::Rackspace::Networking.new

  network_format = {
    'id' => String,
    'label' => String,
    'cidr' => Fog::Nullable::String
  }

  get_network_format = {
    'network' => network_format
  }

  list_networks_format = {
    'networks' => [network_format]
  }

  tests('success') do
    network_id = nil

    tests('#create_network').formats(get_network_format) do
      service.create_network("fog_#{Time.now.to_i.to_s}", '192.168.0.0/24').body.tap do |r|
        network_id = r['network']['id']
      end
    end

    tests('#list_networks').formats(list_networks_format) do
      service.list_networks.body
    end

    tests('#get_network').formats(get_network_format) do
      service.get_network(network_id).body
    end

    tests('#delete_network').succeeds do
      service.delete_network(network_id)
    end
  end

  test('failure') do
    tests('#get_network').raises(Fog::Rackspace::Networking::NotFound) do
      service.get_network(0)
    end

    tests('#delete_network').raises(Fog::Rackspace::Networking::NotFound) do
      service.delete_network(0)
    end
  end
end
