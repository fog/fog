Shindo.tests('Fog::Compute[:google] | firewall requests', ['google']) do
  pending if Fog.mocking?

  @google = Fog::Compute[:google]

  @insert_firewall_format = {
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

  @get_firewall_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'creationTimestamp' => DateTime,
      'name' => String,
      'network' => String,
      'sourceRanges' => [],
      'allowed' => [],
  }

  @delete_firewall_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'name' => String,
      'targetLink' => String,
      'status' => String,
      'user' => String,
      'progress' => Integer,
      'targetId' => String,
      'insertTime' => String,
      'startTime' => String,
      'operationType' => String
  }

  @list_firewalls_format = {
      'kind' => String,
      'id' => String,
      'selfLink' => String,
      'items' => []
  }

  tests('success') do

    firewall_name = 'fog-test-firewall'
    source_range = [ '10.0.0.0/8' ]
    allowed = [{
      "IPProtocol" => "tcp",
      "ports" => [ "1-65535" ]
    }, {
      "IPProtocol" => "udp",
      "ports" => [ "1-65535" ]
    }, {
      "IPProtocol" => "icmp"
    }]

    tests("#insert_firewall").formats(@insert_firewall_format) do
      response = @google.insert_firewall(firewall_name, allowed, 'default', :source_ranges => source_range).body
      wait_operation(@google, response)
      response
    end

    # TODO: Get better matching for firewall responses.
    tests("#get_firewall").succeeds do
      @google.get_firewall(firewall_name)
    end

    tests("#list_firewalls").succeeds do
      @google.list_firewalls
    end

    tests("#delete_firewall").formats(@delete_firewall_format) do
      @google.delete_firewall(firewall_name).body
    end

  end

end
