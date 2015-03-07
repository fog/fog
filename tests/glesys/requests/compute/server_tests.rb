Shindo.tests('Fog::Compute[:glesys] | server requests', ['glesys']) do

    @serverid = nil
    @hostname = "fog-#{Time.now.to_i}"

    @create = ":hostname => #@hostname, :rootpassword => 'pw#{Time.now.to_i}', "+
    ":datacenter => 'Falkenberg', :platform => 'VMware', :templatename => 'Debian 7.0 64-bit', "+
    ":disksize => '10', :memorysize => '512', :cpucores => '1', :transfer => '500', :bandwidth => '10'"

    @create_vz = ":hostname => #@hostname, :rootpassword => 'pw#{Time.now.to_i}', "+
    ":datacenter => 'Stockholm', :platform => 'OpenVZ', :templatename => 'Debian 7.0 64-bit', "+
    ":disksize => '10', :memorysize => '256', :cpucores => '2', :transfer => '500', :bandwidth => '10'"

  tests('success') do

    tests("#list_servers()").formats(Glesys::Compute::Formats::Servers::LIST) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].list_servers.body['response']
    end

    tests("#create(#{@create})").formats(Glesys::Compute::Formats::Servers::CREATE) do
      pending if Fog.mocking?
      vm =  Fog::Compute[:glesys].create(
              :hostname     => @hostname,
              :description  => "Fog test server",
              :rootpassword => "pw#{Time.now.to_i}",
              :datacenter   => "Falkenberg",
              :platform     => "VMware",
              :templatename => "Debian 7.0 64-bit",
              :disksize     => "10",
              :memorysize   => "512",
              :cpucores     => "1",
              :transfer     => "500",
              :bandwidth    => "10"
            )

      @serverid = vm.body['response']['server']['serverid']
      vm.body['response']
    end

    unless Fog.mocking?
      Fog::Compute[:glesys].servers.get(@serverid).wait_for { ready? }
    end

    tests("#server_details(#{@serverid})").formats(Glesys::Compute::Formats::Servers::DETAILS) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].server_details(@serverid).body['response']
    end

    tests("#server_status(#{@serverid})").formats(Glesys::Compute::Formats::Servers::STATUS) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].server_status(@serverid).body['response']
    end

    tests("#stop(:serverid => #{@serverid})").formats(Glesys::Compute::Formats::Servers::STOP) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].stop(:serverid => @serverid).body['response']
    end

    # Wait for stopped
    unless Fog.mocking?
      pending if Fog.mocking?
      s = Fog::Compute[:glesys].servers.get(@serverid)
      s.wait_for { s.state == 'stopped' }
    end

    tests("#start(:serverid => #{@serverid})").formats(Glesys::Compute::Formats::Servers::DETAILS) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].start(:serverid => @serverid).body['response']
    end

    # Wait for started
    unless Fog.mocking?
      Fog::Compute[:glesys].servers.get(@serverid).wait_for { ready? }
    end

    tests("#destroy(:serverid => #{@serverid})").formats(Glesys::Compute::Formats::Servers::DESTROY) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].destroy(:serverid => @serverid).body['response']
    end

    # Test of OpenVZ
    tests("#create(#{@create_vz})").formats(Glesys::Compute::Formats::Servers::CREATE) do
      pending if Fog.mocking?
      vm =  Fog::Compute[:glesys].create(
              :hostname     => @hostname,
              :rootpassword => "pw#{Time.now.to_i}",
              :datacenter   => "Stockholm",
              :platform     => "OpenVZ",
              :templatename => "Debian 7.0 64-bit",
              :disksize     => "10",
              :memorysize   => "256",
              :cpucores     => "2",
              :transfer     => "500",
              :bandwidth    => "10"
            )
      @serverid = vm.body['response']['server']['serverid']
      vm.body['response']
    end

    unless Fog.mocking?
      Fog::Compute[:glesys].servers.get(@serverid).wait_for { ready? }
    end

    tests("#edit #{@serverid}").formats(Glesys::Compute::Formats::Servers::EDIT) do
      pending if Fog.mocking?
      vm = Fog::Compute[:glesys].edit(
        :serverid => @serverid,
        :disksize => "10",
        :memorysize => "512",
        :cpucores => "1",
        :bandwidth => "10"
      )
      vm.body['response']
    end

    tests("#server_details(#{@serverid})").formats(Glesys::Compute::Formats::Servers::DETAILS) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].server_details(@serverid).body['response']
    end

    unless Fog.mocking?
      Fog::Compute[:glesys].servers.get(@serverid).wait_for { ready? }
    end

    tests("#destroy(:serverid => #{@serverid})").formats(Glesys::Compute::Formats::Servers::DESTROY) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].destroy(:serverid => @serverid).body['response']
    end

  end

  tests('failure') do

    tests("#create(:hostname => 0)").raises(Excon::Errors::HTTPStatusError) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].create(:hostname => 0)
    end

  end

end
