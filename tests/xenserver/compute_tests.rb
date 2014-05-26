Shindo.tests('Fog::Compute[:xenserver]', ['xenserver']) do

  compute = Fog::Compute[:xenserver]

  tests("Compute attributes") do
    %w{ default_template }.each do |attr|
      test("it should respond to #{attr}") { compute.respond_to? attr }
    end
  end

  tests("Compute collections") do
    %w{ pifs vifs hosts storage_repositories servers networks vbds vdis pools consoles}.each do |collection|
      test("it should respond to #{collection}") { compute.respond_to? collection }
      test("it should respond to #{collection}.all") { eval("compute.#{collection}").respond_to? 'all' }
      test("it should respond to #{collection}.get") { eval("compute.#{collection}").respond_to? 'get' }
    end
    # This will fail if there are no PIFs
    # (not sure if that's gonna be a real scenario though)
    tests("PIFs collection") do
      test("should have at least one PIF") { compute.pifs.size >= 1 }
    end

    # This will fail if there are no VIFs
    # (not sure if that's gonna be a real scenario though)
    tests("VIFs collection") do
      test("should have at least one VIF") { compute.vifs.size >= 1 }
    end

    # This will fail if there are no VIFs
    # (not sure if that's gonna be a real scenario though)
    tests("Networks collection") do
      test("should have at least one Network") { compute.networks.size >= 1 }
      tests("each network should be a Fog::Compute::XenServer::Network") do
        ok = true
        compute.networks.each { |n| ok = false if n.kind_of? Fog::Compute::XenServer::Network }
      end
    end
  end

  tests "Default template" do
    test("it should NOT have a default template") { compute.default_template.nil? }
    # This template exists in our XenServer
    compute.default_template = 'squeeze-test'
    test("it should have a default template if template exists") { compute.default_template.name == 'squeeze-test' }
    test("it should be a Fog::Compute::XenServer::Server") { compute.default_template.is_a? Fog::Compute::XenServer::Server }
    test("it should return nil when not found") do
      compute.default_template = 'asdfasdfasfdwe'
      compute.default_template.nil?
    end
  end
end
