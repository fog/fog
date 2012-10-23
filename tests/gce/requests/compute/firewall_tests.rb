Shindo.tests('Fog::Compute[:gce] | firewall requests', ['gce']) do

  @gce = Fog::Compute[:gce]

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
      @gce.insert_firewall(firewall_name, source_range, allowed).body
    end

    tests("#get_firewall").formats(@get_firewall_format) do
      @gce.get_firewall(firewall_name).body
    end

    tests("#list_firewalls").formats(@list_firewalls_format) do
      @gce.list_firewalls.body
    end

    tests("#delete_firewall").formats(@delete_firewall_format) do
      @gce.delete_firewall(firewall_name).body
    end

  end

end
