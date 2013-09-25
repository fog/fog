Shindo.tests('Fog::Compute::RackspaceV2 | server_tests', ['rackspace']) do
  service   = Fog::Compute.new(:provider => 'Rackspace', :version => 'V2')
  image_id  = Fog.credentials[:rackspace_image_id]
  image_id ||= Fog.mocking? ? service.images.first.id : service.images.find {|image| image.name =~ /Ubuntu/}.id # use the first Ubuntu image
  flavor_id = Fog.credentials[:rackspace_flavor_id] || service.flavors.first.id

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

  rescue_server_format = {
    'adminPass' => Fog::Nullable::String
  }

  tests('success') do

    server_id = nil
    server_name = "fog#{Time.now.to_i.to_s}"
    image_id = image_id
    flavor_id = flavor_id

    tests("#create_server(#{server_name}, #{image_id}, #{flavor_id}, 1, 1)").formats(create_server_format) do
      body = service.create_server(server_name, image_id, flavor_id, 1, 1).body
      server_id = body['server']['id']
      body
    end
    wait_for_server_state(service, server_id, 'ACTIVE', 'ERROR')
    
    tests('#list_servers').formats(list_servers_format, false) do
      service.list_servers.body
    end

    tests('#get_server').formats(get_server_format, false) do
      service.get_server(server_id).body
    end

    tests("#update_server(#{server_id}, #{server_name}_update) LEGACY").formats(get_server_format) do
      service.update_server(server_id, "#{server_name}_update").body
    end
    
    tests("#update_server(#{server_id}, { 'name' => #{server_name}_update)} ").formats(get_server_format) do
      service.update_server(server_id, 'name' => "#{server_name}_update").body
    end    

    tests('#change_server_password').succeeds do
      service.change_server_password(server_id, 'some_server_password')
    end
    wait_for_server_state(service, server_id, 'ACTIVE', 'ERROR')

    tests('#reboot_server').succeeds do
      service.reboot_server(server_id, 'SOFT')
    end
    wait_for_server_state(service, server_id, 'ACTIVE')

    tests('#rebuild_server').succeeds do
      rebuild_image_id = image_id
      service.rebuild_server(server_id, rebuild_image_id)
    end
    wait_for_server_state(service, server_id, 'ACTIVE', 'ERROR')
    sleep 120 unless Fog.mocking?
    
    tests('#resize_server').succeeds do
      resize_flavor_id = Fog.mocking? ? flavor_id : service.flavors[1].id
      service.resize_server(server_id, resize_flavor_id)
    end
    wait_for_server_state(service, server_id, 'VERIFY_RESIZE', 'ACTIVE')
    
   tests('#confirm_resize_server').succeeds do
      service.confirm_resize_server(server_id)
    end
    wait_for_server_state(service, server_id, 'ACTIVE', 'ERROR')

    tests('#resize_server').succeeds do
      resize_flavor_id = Fog.mocking? ? flavor_id : service.flavors[1].id
      service.resize_server(server_id, resize_flavor_id)
    end
    wait_for_server_state(service, server_id, 'VERIFY_RESIZE', 'ACTIVE')

    tests('#revert_resize_server').succeeds do
      service.revert_resize_server(server_id)
    end
    wait_for_server_state(service, server_id, 'ACTIVE', 'ERROR')

    tests('#rescue_server').formats(rescue_server_format, false) do
      service.rescue_server(server_id)
    end
    wait_for_server_state(service, server_id, 'RESCUE', 'ACTIVE')

    tests('#unrescue_server').succeeds do
      service.unrescue_server(server_id)
    end
    wait_for_server_state(service, server_id, 'ACTIVE', 'ERROR')

    tests('#delete_server').succeeds do
      service.delete_server(server_id)
    end    
  end 
end
