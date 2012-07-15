Shindo.tests('Fog::Compute[:serverlove] | server requests', ['serverlove']) do
  
  @server_format = {
    'server'            => String,
    'name'              => String,
    'user'              => String,
    'status'            => String,
    'started'           => String,
    'cpu'               => Integer,
    'persistent'        => Fog::Nullable::String,
    'vnc:password'      => String
  }
  
  tests('success') do
    
    attributes = { 'name' => 'Test', 'cpu' => '1000', 'persistent' => 'true' }

    tests("#create_server").formats(@server_format) do
      @server = Fog::Compute[:serverlove].create_server(attributes).body
    end

    tests("#list_servers").succeeds do
      Fog::Compute[:serverlove].servers
    end
    
    tests("#update_server").returns(true) do
      @server['name'] = "Diff"
      Fog::Compute[:serverlove].update_server(@server['server'], { name: @server['name']})
      Fog::Compute[:serverlove].servers.get(@server['server']).name == "Diff"
    end
    
    tests("#start_server").succeeds do
      Fog::Compute[:serverlove].start_server(@server['server'])
    end
    
    tests("#reset_server").succeeds do
      Fog::Compute[:serverlove].reset_server(@server['server'])
    end
    
    tests("#shutdown_server").succeeds do
      Fog::Compute[:serverlove].shutdown_server(@server['server'])
    end
    
    tests("#stop_server").succeeds do
      Fog::Compute[:serverlove].stop_server(@server['server'])
    end

    tests("#destroy_server").succeeds do
      Fog::Compute[:serverlove].destroy_server(@server['server'])
    end

  end

end
