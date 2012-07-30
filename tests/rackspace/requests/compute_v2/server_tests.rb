Shindo.tests('Fog::Compute::RackspaceV2 | server_tests', ['rackspace']) do

  pending if Fog.mocking?

  LINK_FORMAT = {
    'href' => String,
    'rel' => String
  }

  SERVER_FORMAT = {
    'id' => String,
    'name' => String,
    'hostId' => Fog::Nullable::String,
    'created' => Fog::Nullable::String,
    'updated' => Fog::Nullable::String,
    'status' => Fog::Nullable::String,
    'progress' => Fog::Nullable::Integer,
    'user_id' => Fog::Nullable::String,
    'tenant_id' => Fog::Nullable::String,
    'links' => [LINK_FORMAT],
    'metadata' => Fog::Nullable::Hash
  }

  LIST_SERVERS_FORMAT = {
    'servers' => [SERVER_FORMAT]
  }

  GET_SERVER_FORMAT = {
    'server' => SERVER_FORMAT.merge({
      'accessIPv4' => String,
      'accessIPv6' => String,
      'OS-DCF:diskConfig' => String,
      'rax-bandwidth:bandwidth' => Fog::Nullable::Array,
      'addresses' => Fog::Nullable::Hash,
      'flavor' => {
        'id' => String,
        'links' => [LINK_FORMAT]
      },
      'image' => {
        'id' => String,
        'links' => [LINK_FORMAT]
      }
    })
  }

  CREATE_SERVER_FORMAT = {
    'server' => {
      'id' => String,
      'adminPass' => String,
      'links' => [LINK_FORMAT],
      'OS-DCF:diskConfig' => String
    }
  }

  service = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')

  tests('success') do

    server_id = nil
    server_name = 'fog' + Time.now.to_i.to_s
    image_id = '3afe97b2-26dc-49c5-a2cc-a2fc8d80c001' # Ubuntu 11.10
    flavor_id = '2' # 512 MB

    tests("#create_server(#{server_name}, #{image_id}, #{flavor_id}, 1, 1)").formats(CREATE_SERVER_FORMAT) do
      body = service.create_server(server_name, image_id, flavor_id, 1, 1).body
      server_id = body['server']['id']
      body
    end

    tests('#list_servers').formats(LIST_SERVERS_FORMAT) do
      service.list_servers.body
    end

    tests('#get_server').formats(GET_SERVER_FORMAT) do
      service.get_server(server_id).body
    end

    until service.get_server(server_id).body['server']['status'] == 'ACTIVE'
      sleep 10
    end

    tests("#update_server(#{server_id}, #{server_name}_update)").formats(GET_SERVER_FORMAT) do
      service.update_server(server_id, "#{server_name}_update").body
    end

    tests('#change_server_password').succeeds do
      service.change_server_password(server_id, 'some_server_password')
    end

    sleep 60

    tests('#reboot_server').succeeds do
      service.reboot_server(server_id, 'SOFT')
    end

    until service.get_server(server_id).body['server']['status'] == 'ACTIVE'
      sleep 10
    end

    tests('#rebuild_server').succeeds do
      rebuild_image_id = "5cebb13a-f783-4f8c-8058-c4182c724ccd" # Ubuntu 12.04
      service.rebuild_server(server_id, rebuild_image_id)
    end

    until service.get_server(server_id).body['server']['status'] == 'ACTIVE'
      sleep 10
    end

    tests('#resize_server').succeeds do
      resize_flavor_id = 3 # 1GB
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
      resize_flavor_id = 2 # 1GB
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
