Shindo.tests("Fog::Compute[:brightbox] | Server model", ["brightbox"]) do

  pending if Fog.mocking?

  tests("success") do

    unless Fog.mocking?
      @server = Brightbox::Compute::TestSupport.get_test_server
      server_id = @server.id
    end

    tests("#dns_name") do
      pending if Fog.mocking?
      returns("public.#{@server.fqdn}") { @server.dns_name }
    end

    unless Fog.mocking?
      @server.destroy
    end
  end
end
