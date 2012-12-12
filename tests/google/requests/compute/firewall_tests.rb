Shindo.tests('Fog::Compute[:google] | firewall requests', ['gce']) do

  @google = Fog::Compute[:gce]

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
      'creationTimestamp' => String,
      'name' => String,
      'network' => String,
      'sourceRanges' => [],
      'allowed' => []
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

    firewall_name = 'new-firewall-test'
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
      @google.insert_firewall(firewall_name, source_range, allowed).body
    end

    tests("#get_firewall").formats(@get_firewall_format) do
      @google.get_firewall(firewall_name).body
    end

    tests("#list_firewalls").formats(@list_firewalls_format) do
      @google.list_firewalls.body
    end

    tests("#delete_firewall").formats(@delete_firewall_format) do
      @google.delete_firewall(firewall_name).body
    end

  end

end
