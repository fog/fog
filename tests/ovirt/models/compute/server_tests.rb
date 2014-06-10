Shindo.tests('Fog::Compute[:ovirt] | server model', ['ovirt']) do

  servers = Fog::Compute[:ovirt].servers
  server = servers.last

  tests('The server model should') do
    tests('have the action') do
      test('reload') { server.respond_to? 'reload' }
      %w{ start stop destroy reboot suspend }.each do |action|
        test(action) { server.respond_to? action }
      end
      %w{ start reboot suspend stop }.each do |action|
        test("#{action} returns successfully") {
          begin
            server.send(action.to_sym) ? true : false
          rescue OVIRT::OvirtException
            #ovirt exceptions are acceptable for the above actions.
            true
          end
        }
      end
    end
    tests('have attributes') do
      model_attribute_hash = server.attributes
      attributes = [ :id,
        :name,
        :description,
        :profile,
        :display,
        :creation_time,
        :os,
        :status,
        :cores,
        :memory,
        :cluster,
        :template]
      tests("The server model should respond to") do
        attributes.each do |attribute|
          test("#{attribute}") { server.respond_to? attribute }
        end
      end
      tests("The attributes hash should have key") do
        attributes.each do |attribute|
          test("#{attribute}") { model_attribute_hash.key? attribute }
        end
      end
    end
    test('be a kind of Fog::Compute::Ovirt::Server') { server.kind_of? Fog::Compute::Ovirt::Server }
  end

end
