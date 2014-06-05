
Shindo.tests('Fog::Compute[:xenserver] | host model', ['xenserver']) do

  hosts = Fog::Compute[:xenserver].hosts
  host = hosts.first

  tests('The host model should') do
    tests('have the action') do
      test('reload') { host.respond_to? 'reload' }
      test('shutdown') { host.respond_to? 'shutdown' }
      test('disable') { host.respond_to? 'disable' }
      test('reboot') { host.respond_to? 'reboot' }
    end

    tests('have attributes') do
      model_attribute_hash = host.attributes
      attributes = [
        :reference,
        :uuid,
        :name,
        :address,
        :allowed_operations,
        :enabled,
        :hostname,
        :__metrics,
        :name_description,
        :other_config,
        :__pbds,
        :__pifs,
        :__resident_vms,
        :__host_cpus,
        :edition,
        :software_version
      ]
      tests("The host model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { host.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end

    test('be a kind of Fog::Compute::XenServer::Host') { host.kind_of? Fog::Compute::XenServer::Host }

  end

  tests("A real host should") do
    tests("return valid PIFs") do
      test("as an array") { host.pifs.kind_of? Array }
      host.pifs.each { |i|
          test("and each PIF should be a Fog::Compute::XenServer::PIF") { i.kind_of? Fog::Compute::XenServer::PIF}
      }
    end
    tests("return valid PBDs") do
      test("as an array") { host.pbds.kind_of? Array }
      host.pbds.each { |i|
          test("and each PBD should be a Fog::Compute::XenServer::PBD") { i.kind_of? Fog::Compute::XenServer::PBD}
      }
    end
    tests("return valid resident servers") do
      test("as an array") { host.resident_servers.kind_of? Array }
      host.resident_servers.each { |i|
          test("and each Server should be a Fog::Compute::XenServer::Server") { i.kind_of? Fog::Compute::XenServer::Server}
      }
    end
    tests("return valid HostMetrics") do
      test("object") { host.metrics.kind_of? Fog::Compute::XenServer::HostMetrics }
    end

    tests('be able to be') do
      test('disable') do
        host.disable
        host.reload
        host.enabled == false
      end
      test('enabled') do
        host.enable
        host.reload
        host.enabled
      end
    end

    tests('return a list of HostCpu') do
      test('as an Array') do
        host.host_cpus.kind_of? Array
      end
      test('with one element at least') do
        host.host_cpus.first.kind_of? Fog::Compute::XenServer::HostCpu
      end
    end

  end

end
