Shindo.tests('Fog::Compute[:glesys] | server requests', ['glesys']) do
    
    @serverid = nil
    @hostname = "fog.#{Time.now.to_i}"

    @create = ":hostname => #@hostname, :rootpw => 'pw#{Time.now.to_i}', "+
    ":datacenter => 'Falkenberg', :platform => 'Xen', :template => 'Debian-6 x64', "+
    ":disksize => '10', :memorysize => '512', :cpucores => '1', :transfer => '500'"

  tests('success') do

    tests("#list_servers()").formats(Glesys::Compute::Formats::Servers::LIST) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].list_servers.body['response']
    end

    tests("#create(#{@create})").formats(Glesys::Compute::Formats::Servers::CREATE) do
      pending if Fog.mocking?
      vm =  Fog::Compute[:glesys].create(
              :hostname   => @hostname,
              :rootpw     => "pw#{Time.now.to_i}",
              :datacenter => "Falkenberg",
              :platform   => "Xen",
              :template   => "Debian-6 x64",
              :disksize   => "10",
              :memorysize => "512",
              :cpucores   => "1",
              :transfer   => "500"
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

    tests("#start(:serverid => #{@serverid})").formats(Glesys::Compute::Formats::Servers::START) do
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

  end

  tests('failure') do

    tests("#create(:hostname => 0)").raises(Excon::Errors::HTTPStatusError) do
      pending if Fog.mocking?
      Fog::Compute[:glesys].create(:hostname => 0)
    end

  end

end
