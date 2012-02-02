Shindo.tests('Fog::Compute[:ovirt] | server model', ['ovirt']) do

  servers = Fog::Compute[:ovirt].servers
  server = servers.last

  tests('The server model should') do
    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{ stop start destroy reboot }.each do |action|
        test(action) { server.respond_to? action }
      end
    end
    tests('have attributes') do
      model_attribute_hash = server.attributes
      attributes = [ :id,
        :name,
        :description,
        :profile,
        :display,
        :storage,
        :creation_time,
        :os,
        :ip,
        :status,
        :cores,
        :memory,
        :host,
        :cluster,
        :template]
      tests("The server model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { server.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.has_key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Ovirt::Server') { server.kind_of? Fog::Compute::Ovirt::Server }
  end

  # currently not mock is not working..
end if false
