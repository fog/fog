Shindo.tests('Stormondemand::Compute | server requests', ['stormondemand']) do

  @servers_format = {
    'servers'  => [{
      'uniq_id'     => String,
      'accnt'       => String,
      'backup_enabled'     => String, #boolean?
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
    }]
  }

  tests('success') do

    @uniq_id = nil
    @name = "fog-test#{Time.now.to_i}.com"

    tests("#create_server(:backup_enabled => 0, :config_id => 114, :domain => '#{@name}', :template => 'CENTOSUNMANAGED', :ip_count => 1, :password => 'B92bxfijsdK3!')").formats(@servers_format) do
      pending if Fog.mocking?
      data = Stormondemand[:compute].create_server(:backup_enabled => 0,  :config_id => 114, :domain => @name, :template => 'CENTOSUNMANAGED', :ip_count => 1, :password => 'B92bxfijsdK3!').body
      @uniq_id = data['uniq_id']
      data
    end

    unless Fog.mocking?
      Stormondemand[:compute].servers.get(@server_id).wait_for { ready? }
    end

    tests("#delete_server(#{@uniq_id})").succeeds do
      pending if Fog.mocking?
      Stormondemand[:compute].delete_server(@uniq_id)
    end

    tests('#list_servers').formats(@server_format) do
      pending if Fog.mocking?
      Stormondemand[:compute].list_servers.body
    end

  end

  tests('failure') do
    tests('#delete_server(0)').raises(Fog::Stormondemand::Compute::Error) do
      pending if Fog.mocking?
      Stormondemand[:compute].delete_server(0)
    end
  end

end
