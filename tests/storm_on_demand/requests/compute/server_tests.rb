Shindo.tests('Fog::Compute[:stormondemand] | server requests', ['stormondemand']) do

  @server_format = {
      'uniq_id'     => String,
      'accnt'       => String,
      'backup_enabled'     => String,
      'backup_plan'     => String,
      'backup_size'     => String,
      'backup_quota'     => String,
      'bandwidth_quota' => Integer,
      'config_description'     => String,
      'config_id'     => String,
      'domain'     => String,
      'ip'     => String,
      'ip_count'     => String,
      'subaccnt'     => String,
      'template'     => String,
      'template_description'     => String,
      'manage_level'     => String,
      'zone'     => Hash,
      'active' => Integer,
      'create_date' => String
  }
  
  @servers_format = {
    'items' => [@server_format]
  }
    
  tests('success') do

    @uniq_id = nil
    @name = "fog-test#{Time.now.to_i}.com"

    tests("#create_server(:backup_enabled => 0, :config_id => 114, :domain => '#{@name}', :template => 'CENTOSUNMANAGED', :ip_count => 1, :password => 'B92bxfijsdK3!')").formats(@server_format) do
      pending if Fog.mocking?
      data = Fog::Compute[:stormondemand].create_server(:backup_enabled => 0,  :config_id => 114, :domain => @name, :template => 'CENTOSUNMANAGED', :ip_count => 1, :password => 'B92bxfijsdK3!').body
      @uniq_id = data['uniq_id']
      data
    end

    tests('#list_servers').formats(@servers_format) do
      pending if Fog.mocking?
      Fog::Compute[:stormondemand].list_servers.body
    end

    unless Fog.mocking?
      Fog::Compute[:stormondemand].servers.get(@uniq_id).wait_for { ready? }
    end

    tests("#delete_server(:uniq_id => #{@uniq_id})").succeeds do
      pending if Fog.mocking?
      Fog::Compute[:stormondemand].delete_server(:uniq_id => @uniq_id)
    end

  end

  tests('failure') do
    tests('#delete_server(0)').raises(Fog::Compute::StormOnDemand::Error) do
      pending if Fog.mocking?
      Fog::Compute[:stormondemand].delete_server(:uniq_id => 'XXXXXX')
    end
  end

end
