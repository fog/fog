Shindo.tests('Fog::Compute[:brightbox] | interface requests', ['brightbox']) do

  @test_service = Fog::Compute[:brightbox]

  tests('success') do

    unless Fog.mocking?
      server = @test_service.servers.first

      # If no server is available, create one just for the test
      unless server
        @test_server = Brightbox::Compute::TestSupport.get_test_server
        server = @test_server
      end

      @interface_id = server.interfaces.first["id"]
    end

    tests("#get_interface('#{@interface_id}')") do
      pending if Fog.mocking?
      result = @test_service.get_interface(@interface_id)
      formats(Brightbox::Compute::Formats::Full::INTERFACE, false) { result }
    end

    unless Fog.mocking?
      # If we created a server just for this test, clean it up
      @test_server.destroy if @test_server
    end

  end

  tests('failure') do

    tests("#get_interface('int-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      @test_service.get_interface('int-00000')
    end

    tests("#get_interface()").raises(ArgumentError) do
      pending if Fog.mocking?
      @test_service.get_interface()
    end
  end

end
