Shindo.tests("Fog::Compute[:azure] | server model", ["azure", "compute"]) do

  server  = fog_test_server

  tests("The server model should") do
    pending if Fog.mocking?
    tests("have the action") do
      test("reload") { server.respond_to? "reload" }
      %w{
        destroy
        reboot
        shutdown
        start
      }.each do |action|
        test(action) { server.respond_to? action }
      end
    end

    tests("have attributes") do
      attributes = [
        :vm_name,
        :status,
        :ipaddress,
        :cloud_service_name,
        :image,
        :location,
        :os_type,
        :storage_account_name
      ]
      tests("The server model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { server.respond_to? attribute }
        end
      end
    end

    test("#reboot") do
      server.reboot
      server = fog_test_server
      %w(ReadyRole Provisioning RoleStateUnknown).include?  server.status
    end

    test("#start") do
      server.start
      status = %w(ReadyRole Provisioning RoleStateUnknown)
      status.include?  server.status
    end

    test("#shutdown") do
      server.shutdown
      server = fog_test_server
      %w(StoppedVM StoppedDeallocated).include?  server.status
    end

    test("#destroy") do
      server.destroy
      server = service.servers.select { |s| s.vm_name == vm_name }.first
      server.nil?
    end
  end

end
