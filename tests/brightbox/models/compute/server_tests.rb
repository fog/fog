Shindo.tests("Fog::Compute[:brightbox] | Server model", ["brightbox"]) do
  pending if Fog.mocking?

  tests("success") do
    @server = Brightbox::Compute::TestSupport.get_test_server
    server_id = @server.id

    tests("#dns_name") do
      returns("public.#{@server.fqdn}") { @server.dns_name }
    end

    tests("#mapping_identity") do
      first_interface_id = @server.interfaces.first["id"]
      returns(first_interface_id) { @server.mapping_identity }
    end

    @server.destroy
  end
end
