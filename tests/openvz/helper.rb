
# Shortcut for Fog::Compute[:openvz]
def openvz_service
  Fog::Compute[:openvz]
end

# Create a long lived server for the tests
def openvz_fog_test_server
  server = openvz_service.servers.find { |s| s.ctid == '104' }
  unless server
    server = openvz_service.servers.create :ctid      => '104'
    server.start
    server.reload
    # Wait for the server to come up
    begin
      server.wait_for(120) { server.reload rescue nil; server.ready? }
    rescue Fog::Errors::TimeoutError
      # Server bootstrap took more than 120 secs!
    end
  end

  openvz_fog_test_cleanup

  server
end

# Destroy the long lived server
def openvz_fog_test_server_destroy
  server = openvz_service.servers.find { |s| s.ctid == '104' }
  server.destroy if server
end

# Prepare a callback to destroy the long lived test server
def openvz_fog_test_cleanup
  at_exit do
    unless Fog.mocking?
      server = openvz_service.servers.find { |s| s.name == '104' }
      if server
        server.wait_for(120) do
          reload rescue nil; ready?
        end
      end
      server.stop
      openvz_fog_test_server_destroy
    end
  end
end
