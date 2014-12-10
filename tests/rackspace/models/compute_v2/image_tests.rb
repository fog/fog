Shindo.tests('Fog::Compute::RackspaceV2 | image', ['rackspace']) do
  service    = Fog::Compute::RackspaceV2.new

  test_time = Time.now.to_i.to_s
  options = {
    :name => "fog_server_#{test_time}",
    :flavor_id => rackspace_test_flavor_id(service),
    :image_id => rackspace_test_image_id(service)
  }

  tests('ready?') do
    @server = Fog::Compute::RackspaceV2::Image.new

    tests('default in ready state').returns(true) do
      @server.state = Fog::Compute::RackspaceV2::Image::ACTIVE
      @server.ready?
    end

    tests('custom ready state').returns(true) do
      @server.state = Fog::Compute::RackspaceV2::Image::SAVING
      @server.ready?(Fog::Compute::RackspaceV2::Image::SAVING)
    end

    tests('default NOT in ready state').returns(false) do
      @server.state = Fog::Compute::RackspaceV2::Image::SAVING
      @server.ready?
    end

    tests('custom NOT ready state').returns(false) do
      @server.state = Fog::Compute::RackspaceV2::Image::UNKNOWN
      @server.ready?(Fog::Compute::RackspaceV2::Image::SAVING)
    end

    tests('default error state').returns(true) do
      @server.state = Fog::Compute::RackspaceV2::Image::ERROR
      exception_occurred = false
      begin
        @server.ready?
      rescue Fog::Compute::RackspaceV2::InvalidImageStateException => e
        exception_occurred = true
        returns(true) {e.desired_state == Fog::Compute::RackspaceV2::Image::ACTIVE }
        returns(true) {e.current_state == Fog::Compute::RackspaceV2::Image::ERROR }
      end
      exception_occurred
    end

    tests('custom error state').returns(true) do
      @server.state = Fog::Compute::RackspaceV2::Image::UNKNOWN
      exception_occurred = false
      begin
        @server.ready?(Fog::Compute::RackspaceV2::Image::SAVING, Fog::Compute::RackspaceV2::Image::UNKNOWN)
      rescue Fog::Compute::RackspaceV2::InvalidImageStateException => e
        exception_occurred = true
        returns(true) {e.desired_state == Fog::Compute::RackspaceV2::Image::SAVING }
        returns(true) {e.current_state == Fog::Compute::RackspaceV2::Image::UNKNOWN }
      end
      exception_occurred
    end
  end

  tests("success") do
    begin
      server = service.servers.create(options)
      server.wait_for { ready? }
      image = server.create_image("fog_image_#{test_time}")

      tests("destroy").succeeds do
        image.destroy
      end
    ensure
      server.destroy if server
    end
  end
end
