Shindo.tests('Fog::Compute[:brightbox] | interface requests', ['brightbox']) do

  tests('success') do

    unless Fog.mocking?
      server = Fog::Compute[:brightbox].servers.first
      @interface_id = server.interfaces.first["id"]
    end

    tests("#get_interface('#{@interface_id}')").formats(Brightbox::Compute::Formats::Full::INTERFACE) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_interface(@interface_id)
    end

  end

  tests('failure') do

    tests("#get_interface('int-00000')").raises(Excon::Errors::NotFound) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_interface('int-00000')
    end

    tests("#get_interface()").raises(ArgumentError) do
      pending if Fog.mocking?
      Fog::Compute[:brightbox].get_interface()
    end
  end

end
