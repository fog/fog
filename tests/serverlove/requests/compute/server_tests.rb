Shindo.tests('Fog::Compute[:serverlove] | server requests', ['serverlove']) do

  @server_format = {
    'server'            => String,
    'name'              => String,
    'user'              => String,
    'status'            => String,
    'started'           => Fog::Nullable::String,
    'cpu'               => Integer,
    'mem'               => Integer,
    'smp'               => Fog::Nullable::String,
    'persistent'        => Fog::Nullable::String,
    'vnc'               => Fog::Nullable::String,
    'vnc:password'      => Fog::Nullable::String,
    'nic:0:dhcp'        => String,
    'nic:0:model'       => String
  }

  tests('success') do

    attributes = { 'name' => 'Test', 'cpu' => '1000', 'mem' => '1000', 'persistent' => 'true' }

    tests("#create_server").formats(@server_format) do
      @server = Fog::Compute[:serverlove].create_server(Fog::Compute::Serverlove::Server.defaults.merge(attributes)).body
    end

    tests("#list_servers").succeeds do
      Fog::Compute[:serverlove].servers
    end

    tests("#update_server").returns(true) do
      @server['name'] = "Diff"
      Fog::Compute[:serverlove].update_server(@server['server'], { :name => @server['name']})
      Fog::Compute[:serverlove].servers.get(@server['server']).name == "Diff"
    end

    tests("assigns drive to server").succeeds do
      @image = Fog::Compute[:serverlove].create_image('name' => 'Test', 'size' => '24234567890').body
      # Load debian
      Fog::Compute[:serverlove].load_standard_image(@image['drive'], 'aca2fa0b-40bc-4e06-ad99-f1467690d5de')
      Fog::Compute[:serverlove].update_server(@server['server'], { 'ide:0:0' => @image['drive'], 'boot' => 'ide:0:0'})
    end

    tests("waits for imaging...").returns(true) do
      while(percent_complete = Fog::Compute[:serverlove].images.get(@image['drive']).imaging)
        sleep(1)
        STDERR.print "#{percent_complete} "
        break if percent_complete.include?("100")
      end
      STDERR.print "100% "
      true
    end

    tests("#start_server").returns(true) do
      Fog::Compute[:serverlove].start_server(@server['server'])
      Fog::Compute[:serverlove].servers.get(@server['server']).status == "active"
    end

    tests("#reset_server").returns(true) do
      Fog::Compute[:serverlove].reset_server(@server['server'])
      Fog::Compute[:serverlove].servers.get(@server['server']).status == "active"
    end

    tests("#shutdown_server").succeeds do
      Fog::Compute[:serverlove].shutdown_server(@server['server'])
      # Can't guarantee the OS will honour this command so don't test status
    end

    tests("#stop_server").returns(true) do
      Fog::Compute[:serverlove].start_server(@server['server'])
      Fog::Compute[:serverlove].stop_server(@server['server'])
      Fog::Compute[:serverlove].servers.get(@server['server']).status == "stopped"
    end

    tests("#destroy_server").succeeds do
      Fog::Compute[:serverlove].destroy_server(@server['server'])
    end

    tests("destroy test drive").succeeds do
      Fog::Compute[:serverlove].destroy_image(@image['drive'])
    end

  end

end
