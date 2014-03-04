Shindo.tests("Fog::Compute[:brightbox] | CloudIp model", ["brightbox"]) do
  pending if Fog.mocking?

  @test_service = Fog::Compute[:brightbox]

  tests("success") do
    @server = Brightbox::Compute::TestSupport.get_test_server
    server_id = @server.id

    @cip = @test_service.cloud_ips.allocate

    tests("#destination_id") do
      returns(true) do
        @cip.respond_to?(:destination_id)
      end

      @cip.map(@server)
      @cip.wait_for { mapped? }

      returns(server_id) do
        @cip.destination_id
      end

      @cip.unmap
      @cip.wait_for { !mapped? }
    end

    @cip.destroy

    @server.destroy
  end
end
