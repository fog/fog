Shindo.tests('Fog::Compute[:brightbox] | interface requests', ['brightbox']) do

  @test_service = Fog::Compute[:brightbox]

  tests('success') do

    unless Fog.mocking?
      @test_server = Brightbox::Compute::TestSupport.get_test_server
      @interface_id = @test_server.interfaces.first["id"]

      tests("#get_interface('#{@interface_id}')") do
        pending if Fog.mocking?
        result = @test_service.get_interface(@interface_id)
        data_matches_schema(Brightbox::Compute::Formats::Full::INTERFACE, {:allow_extra_keys => true}) { result }
      end

      @test_server.destroy
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
