Shindo.tests('Fog::Compute[:serverlove] | server requests', ['serverlove']) do
  
  @server_format = {
    'server'            => String,
    'name'              => String,
    'user'              => String,
    'status'            => String,
    'started'           => Fog::Nullable::String,
    'cpu'               => Integer,
    'mem'               => Integer,
    'persistent'        => Fog::Nullable::String,
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
      Fog::Compute[:serverlove].update_server(@server['server'], { name: @server['name']})
      Fog::Compute[:serverlove].servers.get(@server['server']).name == "Diff"
    end
    
    tests("assigns drive to server").succeeds do
      @image = Fog::Compute[:serverlove].create_image('name' => 'Test', 'size' => '4234567890').body
      # Load centos
      Fog::Compute[:serverlove].load_standard_image(@image['drive'], '88ed067f-d2b8-42ce-a25f-5297818a3b6f')
      @server['ide:0:0'] = @image['drive']
      @server['boot'] = 'ide:0:0' 
      Fog::Compute[:serverlove].update_server(@server['server'], { 'ide:0:0' => @server['ide:0:0'], 'boot' => 'ide:0:0'})
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
