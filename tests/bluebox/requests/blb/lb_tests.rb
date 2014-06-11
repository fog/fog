require 'securerandom'

Shindo.tests('Bluebox::BLB | lb_tests', ['bluebox']) do
  pending if Fog.mocking?

  tests('success') do
    @flavor_id    = compute_providers[:bluebox][:server_attributes][:flavor_id]
    @image_id     = compute_providers[:bluebox][:server_attributes][:image_id]
    @location_id  = compute_providers[:bluebox][:server_attributes][:location_id]
    @password     = SecureRandom.base64(18)

    tests("get_lb_applications").formats(Bluebox::BLB::Formats::LB_APPLICATIONS) do
      @lb_applications = Fog::Bluebox[:blb].get_lb_applications.body
    end

    tests("get_lb_application").formats(Bluebox::BLB::Formats::LB_APPLICATION) do
      Fog::Bluebox[:blb].get_lb_application(@lb_applications.first['id']).body
    end

    tests("get_lb_services").formats(Bluebox::BLB::Formats::LB_SERVICES) do
      @lb_services = Fog::Bluebox[:blb].get_lb_services(@lb_applications.first['id']).body
    end

    tests("get_lb_service").formats(Bluebox::BLB::Formats::LB_SERVICE) do
      Fog::Bluebox[:blb].get_lb_service(@lb_applications.first['id'], @lb_services.first['id']).body
    end

    tests("get_lb_backends").formats(Bluebox::BLB::Formats::LB_BACKENDS) do
      @lb_backends = Fog::Bluebox[:blb].get_lb_backends(@lb_services.first['id']).body
    end

    tests("get_lb_backend").formats(Bluebox::BLB::Formats::LB_BACKEND) do
      Fog::Bluebox[:blb].get_lb_backend(@lb_services.first['id'], @lb_backends.first['id']).body
    end

    # create block
    data = Fog::Compute[:bluebox].create_block(@flavor_id, @image_id, @location_id, {'password' => @password}).body
    @block_id = data['id']
    Fog::Compute[:bluebox].servers.get(@block_id).wait_for { ready? }

    tests("add_machine_to_lb_application").formats(Bluebox::BLB::Formats::ADD_MACHINE_TO_LB) do
      Fog::Bluebox[:blb].add_machine_to_lb_application(@lb_applications.first['id'], @block_id).body
    end

    @default_backend = @lb_backends.select { |x| x['backend_name'] == 'default' }.first
    @id_in_backend = @default_backend['lb_machines'].last['id']
    @machine_opts = { 'port' => 4361, 'backup' => true };
    tests("update_lb_backend_machine(#{@lb_backends.first['id']}, #{@id_in_backend}, #{@machine_opts})").formats(Bluebox::BLB::Formats::LB_MACHINE) do
      Fog::Bluebox[:blb].update_lb_backend_machine(@lb_backends.first['id'], @id_in_backend, @machine_opts).body
    end

    tests("remove_machine_from_lb_backend(#{@default_backend['id']}, #{@id_in_backend})").formats(Bluebox::BLB::Formats::REMOVE_MACHINE_FROM_BACKEND) do
      Fog::Bluebox[:blb].remove_machine_from_lb_backend(@default_backend['id'], @id_in_backend).body
    end

    tests("add_machine_to_lb_backend(#{@default_backend['id']}, #{@block_id})").formats(Bluebox::BLB::Formats::ADD_MACHINE_TO_LB) do
      Fog::Bluebox[:blb].add_machine_to_lb_backend(@default_backend['id'], @block_id).body
    end

    Fog::Compute[:bluebox].destroy_block(@block_id).body

  end

  tests('failure') do
    tests('get_lb_application').raises(Fog::Compute::Bluebox::NotFound) do
      Fog::Bluebox[:blb].get_lb_application('00000000-0000-0000-0000-000000000000')
    end
    tests('get_lb_service').raises(Fog::Compute::Bluebox::NotFound) do
      Fog::Bluebox[:blb].get_lb_service('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000')
    end
    tests('get_lb_backend').raises(Fog::Compute::Bluebox::NotFound) do
      Fog::Bluebox[:blb].get_lb_backend('00000000-0000-0000-0000-000000000000','00000000-0000-0000-0000-000000000000')
    end
  end
end
