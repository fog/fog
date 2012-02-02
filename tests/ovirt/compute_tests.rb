Shindo.tests('Fog::Compute[:ovirt]', ['ovirt']) do

  compute = Fog::Compute[:ovirt]

  tests("Compute attributes") do
    %w{ client }.each do |attr|
      test("it should respond to #{attr}") { compute.respond_to? attr }
    end
  end

  tests("Compute collections") do
    %w{ servers templates clusters }.each do |collection|
      test("it should respond to #{collection}") { compute.respond_to? collection }
    end
  end

  tests("Compute requests") do
    %w{ datacenters storage_domains vm_action destroy_vm }.each do |collection|
      test("it should respond to #{collection}") { compute.respond_to? collection }
    end
  end
end
