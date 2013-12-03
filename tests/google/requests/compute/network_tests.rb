Shindo.tests('Fog::Compute[:google] | network requests', ['google']) do
  pending if Fog.mocking?

  @google = Fog::Compute[:google]

  @insert_network_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'insertTime' => String,
      'startTime' => String,
      'operationType' => String
  }

  @get_network_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => String,
      'name' => String,
      'IPv4Range' => String,
      'gatewayIPv4' => String
  }

  @delete_network_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'targetId' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'insertTime' => String,
      'startTime' => String,
      'operationType' => String
  }

  @list_networks_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => [@get_network_format]
  }

  tests('success') do

    network_name = 'new-network-test'
    ip_range = '192.168.0.0/16'

    tests("#insert_network").formats(@insert_network_format) do
      @google.insert_network(network_name, ip_range).body
    end

    tests("#get_network").formats(@get_network_format) do
      @google.get_network(network_name).body
    end

    tests("#list_networks").formats(@list_networks_format) do
      @google.list_networks.body
    end

    tests("#delete_network").formats(@delete_network_format) do
      @google.delete_network(network_name).body
    end

  end

end
