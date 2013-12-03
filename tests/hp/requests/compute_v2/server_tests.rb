Shindo.tests("Fog::Compute::HPV2 | server requests", ['hp', 'v2', 'compute']) do

  service = Fog::Compute.new(:provider => 'HP', :version => :v2)

  @server_format = {
    'addresses'   => Fog::Nullable::Hash,
    'flavor'      => Hash,
    'id'          => String,
    'image'       => Hash,
    'links'       => [Hash],
    'hostId'      => String,
    'metadata'    => Fog::Nullable::Hash,
    'name'        => String,
    'accessIPv4'  => Fog::Nullable::String,
    'accessIPv6'  => Fog::Nullable::String,
    'progress'    => Fog::Nullable::Integer,
    'status'      => String,
    'created'     => String,
    'updated'     => String,
    'user_id'     => String,
    'tenant_id'   => String,
    'config_drive' => Fog::Nullable::String,
    'security_groups' => [Hash],
    'key_name'    => Fog::Nullable::String
  }

  @list_servers_format = {
    'links' => [Hash],
    'name'  => String,
    'id'    => String
  }

  @get_console_output_format = {
    'output' => String
  }

  @base_image_id = ENV["BASE_IMAGE_ID"] || "7f60b54c-cd15-433f-8bed-00acbcd25a17"

  tests('success') do

    @server_id = nil
    @server_name = 'fogservertests'

    tests("#create_server(#{@server_name}, 100, #{@base_image_id})").formats(@server_format.merge('adminPass' => String)) do
      data = service.create_server(@server_name, 100, @base_image_id).body['server']
      @server_id = data['id']
      data
    end

    tests("#get_server_details(#{@server_id})").formats(@server_format) do
      service.get_server_details(@server_id).body['server']
    end

    tests('#list_servers').formats({'servers' => [@list_servers_format]}) do
      service.list_servers.body
    end

    tests('#list_servers_detail').formats({'servers' => [@server_format]}) do
      service.list_servers_detail.body
    end

    tests("#update_server(#{@server_id}, :name => 'fogupdateserver')").succeeds do
      service.update_server(@server_id, :name => 'fogupdateserver')
    end

    tests("#reboot_server(#{@server_id}, 'SOFT')").succeeds do
      pending unless Fog.mocking?
      service.reboot_server(@server_id, 'SOFT')
    end

    tests("#get_console_output('#{@server_id}', 10)").formats(@get_console_output_format) do
      service.get_console_output(@server_id, 10).body
    end

    #tests("#get_vnc_console('#{@server_id}', 'novnc')").succeeds do
    #  service.get_console_output(@server_id, 'novnc')
    #end

    tests("#delete_server(#{@server_id})").succeeds do
      service.delete_server(@server_id)
    end

  end

  tests('failure') do

    tests('#delete_server(0)').raises(Fog::Compute::HPV2::NotFound) do
      service.delete_server(0)
    end

    tests('#get_server_details(0)').raises(Fog::Compute::HPV2::NotFound) do
      service.get_server_details(0)
    end

    tests("#update_server(0, :name => 'fognonserver')").raises(Fog::Compute::HPV2::NotFound) do
      service.update_server(0, :name => 'fognonserver')
    end

    tests('#reboot_server(0)').raises(Fog::Compute::HPV2::NotFound) do
      service.reboot_server(0)
    end

    tests('#get_console_output(0, 10)').raises(Fog::Compute::HPV2::NotFound) do
      service.get_console_output(0, 10).body
    end

    #tests("#get_vnc_console(0, 'novnc')").raises(Fog::Compute::HPV2::NotFound) do
    #  service.get_console_output(0, 'novnc')
    #end

  end

end
