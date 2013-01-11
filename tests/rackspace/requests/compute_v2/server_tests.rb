service   = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
image_id  = Fog.credentials[:rackspace_image_id] || service.images.first.id
flavor_id = Fog.credentials[:rackspace_flavor_id] || service.flavors.first.id

Shindo.tests('Fog::Compute::RackspaceV2 | server_tests', ['rackspace']) do

  link_format = {
    'href' => String,
    'rel' => String
  }

  server_format = {
    'id' => String,
    'name' => String,
    'hostId' => Fog::Nullable::String,
    'created' => Fog::Nullable::String,
    'updated' => Fog::Nullable::String,
    'status' => Fog::Nullable::String,
    'progress' => Fog::Nullable::Integer,
    'user_id' => Fog::Nullable::String,
    'tenant_id' => Fog::Nullable::String,
    'links' => [link_format],
    'metadata' => Fog::Nullable::Hash
  }

  list_servers_format = {
    'servers' => [server_format]
  }

  get_server_format = {
    'server' => server_format.merge({
      'accessIPv4' => String,
      'accessIPv6' => String,
      'OS-DCF:diskConfig' => String,
      'rax-bandwidth:bandwidth' => Fog::Nullable::Array,
      'addresses' => Fog::Nullable::Hash,
      'flavor' => {
        'id' => String,
        'links' => [link_format]
      },
      'image' => {
        'id' => String,
        'links' => [link_format]
      }
    })
  }

  create_server_format = {
    'server' => {
      'id' => String,
      'adminPass' => String,
      'links' => [link_format],
      'OS-DCF:diskConfig' => String
    }
  }


  tests('success') do

    server_id = nil
    server_name = 'fog' + Time.now.to_i.to_s
    image_id = image_id
    flavor_id = flavor_id

    tests("#create_server(#{server_name}, #{image_id}, #{flavor_id}, 1, 1)").formats(create_server_format) do
      body = service.create_server(server_name, image_id, flavor_id, 1, 1).body
      server_id = body['server']['id']
      body
    end

    tests('#list_servers').formats(list_servers_format) do
      service.list_servers.body
    end

    tests('#get_server').formats(get_server_format) do
      body = service.get_server(server_id).body
      body
    end

    until service.get_server(server_id).body['server']['status'] == 'ACTIVE'
      sleep 10
    end

    tests("#update_server(#{server_id}, #{server_name}_update)").formats(get_server_format) do
      service.update_server(server_id, "#{server_name}_update").body
    end

    tests('#change_server_password').succeeds do
      service.change_server_password(server_id, 'some_server_password')
    end

    unless Fog.mocking?
      sleep 60
    end

    tests('#reboot_server').succeeds do
      service.reboot_server(server_id, 'SOFT')
    end

    until service.get_server(server_id).body['server']['status'] == 'ACTIVE'
      sleep 10
    end

    tests('#rebuild_server').succeeds do
      rebuild_image_id = image_id
      service.rebuild_server(server_id, rebuild_image_id)
    end

    until service.get_server(server_id).body['server']['status'] == 'ACTIVE'
      sleep 10
    end

    tests('#resize_server').succeeds do
      resize_flavor_id = flavor_id
      service.resize_server(server_id, resize_flavor_id)
    end

    until service.get_server(server_id).body['server']['status'] == 'VERIFY_RESIZE'
      sleep 10
    end

    tests('#confirm_resize_server').succeeds do
      service.confirm_resize_server(server_id)
    end

    until service.get_server(server_id).body['server']['status'] == 'ACTIVE'
      sleep 10
    end

    tests('#resize_server').succeeds do
      resize_flavor_id = flavor_id
      service.resize_server(server_id, resize_flavor_id)
    end

    until service.get_server(server_id).body['server']['status'] == 'VERIFY_RESIZE'
      sleep 10
    end

    tests('#revert_resize_server').succeeds do
      service.revert_resize_server(server_id)
    end

    until service.get_server(server_id).body['server']['status'] == 'ACTIVE'
      sleep 10
    end

    tests('#delete_server').succeeds do
      service.delete_server(server_id)
    end
  end
end
