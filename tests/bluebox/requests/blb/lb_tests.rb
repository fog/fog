require 'securerandom'

Shindo.tests('Bluebox::BLB | lb_tests', ['bluebox']) do
  pending if Fog.mocking?
  
  tests('success') do
    @flavor_id    = compute_providers[:bluebox][:server_attributes][:flavor_id]
    @image_id     = compute_providers[:bluebox][:server_attributes][:image_id]
    @location_id  = compute_providers[:bluebox][:server_attributes][:location_id]
    @password     = SecureRandom.base64(18)

    @lb_applications = nil

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

    tests("get_lb_backends").formats(Bluebox::BLB::Formats::LB_BACKEND) do
    end

    tests("get_lb_backend").formats(Bluebox::BLB::Formats::LB_BACKEND) do
    end
    #data = Fog::Compute[:bluebox].create_block(@flavor_id, @image_id, @location_id, {'password' => @password}).body
    #@block_id = data['id']
    #Fog::Compute[:bluebox].servers.get(@block_id).wait_for { ready? }
    #Fog::Compute[:bluebox].destroy_block(@block_id).body
  end

  tests('failure') do
  end
end
