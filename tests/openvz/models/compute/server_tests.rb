Shindo.tests("Fog::Compute[:openvz] | server model", ['openvz', 'compute']) do

  server  = openvz_fog_test_server

  tests('The server model should') do

    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{
        destroy
        mount
        umount
        restart
        stop
        start
        quotaon
        quotaoff
        quotainit
        suspend
        resume
      }.each do |action|
        test(action) { server.respond_to? action }
      end
    end
    tests('have attributes') do
      model_attribute_hash = server.attributes
      attributes = [
        :ctid,
        :description
      ]
      tests("The server model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { server.respond_to? attribute }
        end
      end
    end
    test('#stop') do
      pending if Fog.mocking?
      server.stop
      server.wait_for { server.status == 'stopped' }
      server.status == 'stopped'
    end
    test('#start') do
      pending if Fog.mocking?
      server.start
      server.wait_for { ready? }
      server.ready?
    end

  end

  # restore server status
  server.start

end
