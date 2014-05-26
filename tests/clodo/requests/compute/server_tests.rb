Shindo.tests('Fog::Compute[:clodo] | server requests', ['clodo']) do

  @ip_format = {
    'primary_ip'  => Fog::Boolean,
    'isp'         => Fog::Boolean,
    'ip'          => String
  }

  @server_format = {
    'addresses' => {
      'public'  => [@ip_format]
    },
    'id'        => String,
    'imageId'   => String,
    'name'      => String,
    'type'      => String,
    'status'    => String
  }

  @server_details_format = @server_format.merge({
                                                  'id' => Integer,
                                                  'vps_createdate' => String,
                                                  'vps_hdd_max' => String,
                                                  'vps_traff' => NilClass,
                                                  'vps_mem_1h_max' => String,
                                                  'vps_mem_load' => String,
                                                  'vps_user_pass' => String,
                                                  'vps_vnc_pass' => String,
                                                  'vps_adddate' => String,
                                                  'vps_os_title' => String,
                                                  'vps_update' => String,
                                                  'vps_mem_1h_min' => String,
                                                  'vps_mem_1h_avg' => NilClass,
                                                  'vps_memory_max' => String,
                                                  'vps_os_version' => String,
                                                  'vps_cpu_1h_max' => String,
                                                  'vps_hdd_load' => String,
                                                  'vps_disk_load' => String,
                                                  'vps_os_type' => String,
                                                  'vps_memory' => String,
                                                  'vps_cpu_load' => String,
                                                  'vps_update_days' => String,
                                                  'vps_os_bits' => String,
                                                  'vps_vnc' => String,
                                                  'vps_cpu_max' => String,
                                                  'vps_cpu_1h_min' => String,
                                                  'vps_cpu_1h_avg' => NilClass,
                                                  'vps_root_pass' => String
  })

  @server_create_format = {
    'name'      => String,
    'adminPass' => String,
    'imageId'   => String,
    'id'        => Integer
  }

#  Fog.mock!

  clodo = Fog::Compute[:clodo]

  tests('success') do
    tests('- create_server(541)').formats(@server_create_format) do
      data = clodo.create_server(541,{:vps_type => 'ScaleServer'}).body['server']
      @server_id = data['id']
      data
    end

    tests('- list_servers(ready)').formats([@server_format]) do
      clodo.list_servers.body['servers'].reject {|s| !['is_running', 'is_disabled'].include?(s['status']) }
    end

    tests('- list_servers(not ready)').formats([@server_format.merge({'addresses'=>{'public'=>NilClass}})]) do
      clodo.list_servers.body['servers'].reject {|s| !['is_request'].include?(s['status']) }
    end

    clodo.servers.get(@server_id).wait_for { ready? || state == 'is_error' } unless Fog.mocking?

    tests("- add_ip_address(#{@server_id})").succeeds do
      clodo.add_ip_address(@server_id)
    end

    # tests("- get_server_details(#{@server_id})").formats(@server_details_format) do
    #   data = clodo.get_server_details(@server_id).body['server']
    #   @additional_ip = data['addresses']['public'].select {|a| !a['primary_ip'] }.first
    #   data
    # end

    tests("- reboot_server(#{@server_id})").succeeds do
      clodo.reboot_server(@server_id, :hard)
    end

    clodo.servers.get(@server_id).wait_for { ready? || state == 'is_error' } unless Fog.mocking?

    # tests("- delete_ip_address(#{@server_id}, #{@additional_ip['ip']})").success do
    #   clodo.delete_ip_address(@server_id, @additional_ip['ip'])
    # end

    tests("- stop_server(#{@server_id})").succeeds do
      clodo.stop_server(@server_id)
    end

    unless Fog.mocking?
      clodo.servers.get(@server_id).wait_for { state == 'is_disabled' || state == 'is_error' }
    end

    tests("- start_server(#{@server_id})").succeeds do
      clodo.start_server(@server_id)
    end

    clodo.servers.get(@server_id).wait_for { ready? || state == 'is_error' } unless Fog.mocking?

    tests("- delete_server(#{@server_id})").succeeds do
      clodo.delete_server(@server_id)
    end
  end

  tests('failure') do
    tests('- create_server(0)').raises(Excon::Errors::BadRequest) do
      data = clodo.create_server(0,{:vps_type => 'ScaleServer'}).body['server']
      @server_id = data['id']
      data
    end

    tests("- reboot_server(0)").raises(Excon::Errors::BadRequest) do
      clodo.reboot_server(0, :hard)
    end

    tests("- stop_server(0)").raises(Excon::Errors::BadRequest) do
      clodo.stop_server(0)
    end

    tests("- start_server(0)").raises(Excon::Errors::BadRequest) do
      clodo.start_server(0)
    end

    ## delete_server(0) in actual API, works not as it must,
    ## so I do not include this test in tests sequence.
    # tests("- delete_server(0)").raises(Fog::Compute::Clodo::NotFound) do
    #   clodo.delete_server(0)
    # end
    #
    # tests("- delete_ip_address(0, 6.6.6.6)").raises(Fog::Compute::Clodo::NotFound) do
    #   clodo.delete_ip_address(0, "6.6.6.6")
    # end

    tests("- delete_ip_address(#{@server_id}, 6.6.6.6)").raises(Excon::Errors::BadRequest) do
      clodo.delete_ip_address(@server_id, "6.6.6.6")
    end

  end
end
